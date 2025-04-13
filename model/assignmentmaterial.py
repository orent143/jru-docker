from fastapi import Depends, HTTPException, APIRouter, Form, File, UploadFile, FastAPI
from pydantic import BaseModel
import os
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles
from .db import get_db

router = APIRouter()

UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)  

app = FastAPI()  
app.mount("/uploads", StaticFiles(directory=UPLOAD_DIR), name="uploads")

class AssignmentCreate(BaseModel):
    course_id: int
    title: str
    description: str
    due_date: str
    file_path: str = None  # Use file_path for both files and links

class AssignmentUpdate(BaseModel):
    title: str
    description: str
    due_date: str
    file_path: str = None  # Use file_path for both files and links

@router.post("/assignments")
async def create_assignment(
    course_id: int = Form(...),
    title: str = Form(...),
    description: str = Form(...),
    due_date: str = Form(...),
    file: UploadFile = File(None),
    external_link: str = Form(None), 
    db=Depends(get_db)
):
    cursor, connection = db

    cursor.execute("SELECT user_id FROM courses WHERE course_id = %s", (course_id,))
    course = cursor.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    user_id = course["user_id"]

    file_path = None
    if file:
        os.makedirs(UPLOAD_DIR, exist_ok=True)
        file_path = os.path.join(UPLOAD_DIR, file.filename)
        with open(file_path, "wb") as buffer:
            buffer.write(file.file.read())

        file_path = f"/uploads/{file.filename}"
    elif external_link:
        file_path = external_link  # Store external link in the file_path field

    # Only store in file_path field, external_link is no longer used
    query = """INSERT INTO assignments (course_id, title, description, due_date, file_path, user_id) 
               VALUES (%s, %s, %s, %s, %s, %s)"""
    cursor.execute(query, (course_id, title, description, due_date, file_path, user_id))
    connection.commit()

    assignment_id = cursor.lastrowid
    return {
        "assignment_id": assignment_id,
        "title": title,
        "description": description,
        "due_date": due_date,
        "file_path": file_path,  
        "user_id": user_id
    }

@router.get("/assignments/assignments/{course_id}")
async def get_assignments(course_id: int, db=Depends(get_db)):
    cursor, _ = db

    cursor.execute("SELECT course_name FROM courses WHERE course_id = %s", (course_id,))
    course = cursor.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    course_name = course["course_name"]

    cursor.execute("""
        SELECT a.assignment_id, a.title, a.description, a.due_date, a.file_path, u.name AS instructor_name 
        FROM assignments a
        JOIN users u ON a.user_id = u.user_id
        WHERE a.course_id = %s
    """, (course_id,))

    assignments = cursor.fetchall()

    return {
        "course_name": course_name,
        "assignments": [
            {
                "assignment_id": a["assignment_id"],
                "title": a["title"],
                "description": a["description"],
                "due_date": a["due_date"],
                "file_path": a["file_path"],
                "instructor_name": a["instructor_name"]
            }
            for a in assignments
        ]
    }

@router.get("/assignments/item/{assignment_id}")
async def get_assignment(assignment_id: int, db=Depends(get_db)):
    cursor, _ = db
    query = """
        SELECT assignment_id, title, description, due_date, file_path 
        FROM assignments 
        WHERE assignment_id = %s
    """
    cursor.execute(query, (assignment_id,))
    assignment = cursor.fetchone()

    if not assignment:
        raise HTTPException(status_code=404, detail="Assignment not found")

    file_url = assignment["file_path"] if assignment["file_path"] else None

    return {
        "assignment_id": assignment["assignment_id"],
        "title": assignment["title"],
        "description": assignment["description"],
        "due_date": assignment["due_date"],
        "file_path": file_url
    }


@router.get("/assignments/download/{file_name}")
async def download_file(file_name: str):
    """Download a file from the uploads directory"""
    file_name = os.path.basename(file_name) 
    file_path = os.path.join(UPLOAD_DIR, file_name)

    if os.path.exists(file_path):
        return FileResponse(file_path, headers={"Content-Disposition": f"attachment; filename={file_name}"})
    
    raise HTTPException(status_code=404, detail="File not found")
    
@router.put("/assignments/{assignment_id}")
async def update_assignment(
    assignment_id: int,
    title: str = Form(...),
    description: str = Form(...),
    due_date: str = Form(...),
    file: UploadFile = File(None),
    external_link: str = Form(None),
    db=Depends(get_db)
):
    cursor, connection = db
    
    # Check if assignment exists
    cursor.execute("SELECT * FROM assignments WHERE assignment_id = %s", (assignment_id,))
    existing_assignment = cursor.fetchone()
    if not existing_assignment:
        raise HTTPException(status_code=404, detail="Assignment not found")
    
    # Handle file upload or external link
    file_path = existing_assignment["file_path"]  # Default to existing file path
    
    if file and file.filename:
        # Upload new file
        os.makedirs(UPLOAD_DIR, exist_ok=True)
        file_path = os.path.join(UPLOAD_DIR, file.filename)
        with open(file_path, "wb") as buffer:
            buffer.write(file.file.read())
        file_path = f"/uploads/{file.filename}"
    elif external_link:
        # Use external link in file_path
        file_path = external_link
    
    # Update assignment in database (only use file_path)
    query = """
    UPDATE assignments 
    SET title = %s, description = %s, due_date = %s, file_path = %s
    WHERE assignment_id = %s
    """
    cursor.execute(query, (title, description, due_date, file_path, assignment_id))
    connection.commit()
    
    return {
        "message": "Assignment updated successfully",
        "assignment_id": assignment_id,
        "title": title,
        "description": description,
        "due_date": due_date,
        "file_path": file_path
    }

@router.delete("/assignments/{assignment_id}")
async def delete_assignment(assignment_id: int, db=Depends(get_db)):
    cursor, connection = db
    query = "DELETE FROM assignments WHERE assignment_id = %s"
    cursor.execute(query, (assignment_id,))
    connection.commit()
    if cursor.rowcount == 0:
        raise HTTPException(status_code=404, detail="Assignment not found")
    return {"message": "Assignment deleted successfully"}
