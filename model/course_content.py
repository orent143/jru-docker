from fastapi import Depends, HTTPException, APIRouter, Path, Form, File, UploadFile, FastAPI
from pydantic import BaseModel
import os
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles
from .db import get_db

router = APIRouter()

UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)  

# Add FastAPI app instance and mount static files directory
app = FastAPI()  
app.mount("/uploads", StaticFiles(directory=UPLOAD_DIR), name="uploads")

class CourseContentCreate(BaseModel):
    course_id: int
    title: str
    content: str

class CourseContentUpdate(BaseModel):
    title: str
    content: str

@router.post("/course-content")
async def create_course_content(
    course_id: int = Form(...),
    title: str = Form(...),
    content: str = Form(...),
    file: UploadFile = File(None),
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
        
        # Format the file path for proper static file serving
        file_path = f"/uploads/{file.filename}"

    query = "INSERT INTO course_content (course_id, title, content, file_path, user_id) VALUES (%s, %s, %s, %s, %s)"
    cursor.execute(query, (course_id, title, content, file_path, user_id))
    connection.commit()

    content_id = cursor.lastrowid
    return {
        "content_id": content_id,
        "title": title,
        "content": content,
        "file_path": file_path,
        "user_id": user_id
    }

@router.get("/course-content/{course_id}")
async def get_course_content(course_id: int = Path(..., title="Course ID"), db=Depends(get_db)):
    cursor, _ = db

    cursor.execute("SELECT course_name FROM courses WHERE course_id = %s", (course_id,))
    course = cursor.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    course_name = course["course_name"]

    cursor.execute("""
        SELECT cc.content_id, cc.title, cc.content, cc.file_path, u.name AS instructor_name 
        FROM course_content cc
        JOIN users u ON cc.user_id = u.user_id
        WHERE cc.course_id = %s
    """, (course_id,))

    contents = cursor.fetchall()

    return {
        "course_name": course_name,
        "data": [
            {
                "content_id": content["content_id"],
                "title": content["title"],
                "content": content["content"],
                "file_path": content["file_path"],
                "instructor_name": content["instructor_name"]  
            }
            for content in contents
        ]
    }


@router.get("/course-content/item/{content_id}")
async def get_content_item(content_id: int, db=Depends(get_db)):
    cursor, _ = db
    query = "SELECT content_id, title, content FROM course_content WHERE content_id = %s"
    cursor.execute(query, (content_id,))
    content = cursor.fetchone()

    if not content:
        raise HTTPException(status_code=404, detail="Content not found")

    return {
        "content_id": content["content_id"],
        "title": content["title"],
        "content": content["content"]
    }

@router.put("/course-content/{content_id}")
async def update_course_content(
    content_id: int,
    title: str = Form(...),
    content: str = Form(...),
    file: UploadFile = File(None),
    db=Depends(get_db)
):
    cursor, connection = db

    file_path = None
    if file:
        file_path = os.path.join(UPLOAD_DIR, file.filename)
        with open(file_path, "wb") as buffer:
            buffer.write(file.file.read())
        
        # Format the file path for proper static file serving
        file_path = f"/uploads/{file.filename}"
        
        query = """
            UPDATE course_content SET title = %s, content = %s, file_path = %s 
            WHERE content_id = %s
        """
        cursor.execute(query, (title, content, file_path, content_id))
    else:
        query = """
            UPDATE course_content SET title = %s, content = %s 
            WHERE content_id = %s
        """
        cursor.execute(query, (title, content, content_id))

    connection.commit()

    if cursor.rowcount == 0:
        raise HTTPException(status_code=404, detail="Content not found")

    return {
        "message": "Course content updated successfully",
        "file_path": file_path
    }


@router.delete("/course-content/{content_id}")
async def delete_course_content(content_id: int, db=Depends(get_db)):
    cursor, connection = db
    query = "DELETE FROM course_content WHERE content_id = %s"
    cursor.execute(query, (content_id,))
    connection.commit()
    if cursor.rowcount == 0:
        raise HTTPException(status_code=404, detail="Content not found")
    return {"message": "Course content deleted successfully"}

@router.get("/course-content/download/{file_name}")
async def download_course_file(file_name: str):
    """Download a file from the uploads directory"""
    file_name = os.path.basename(file_name)  # Ensure we only get the filename without path
    file_path = os.path.join(UPLOAD_DIR, file_name)

    if os.path.exists(file_path):
        return FileResponse(file_path, headers={"Content-Disposition": f"attachment; filename={file_name}"})
    
    raise HTTPException(status_code=404, detail="File not found")
