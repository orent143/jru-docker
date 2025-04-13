from fastapi import Depends, HTTPException, APIRouter, Form, File, UploadFile, FastAPI
import os
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles
from .db import get_db

router = APIRouter()

UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)  

app = FastAPI()  
app.mount("/uploads", StaticFiles(directory=UPLOAD_DIR), name="uploads")

@router.post("/exams")
async def create_exam(
    course_id: int = Form(...),
    title: str = Form(...),
    description: str = Form(...),
    exam_date: str = Form(...),
    duration_minutes: int = Form(...),
    file: UploadFile = File(None),
    external_link: str = Form(None),  
    db=Depends(get_db)
):
    cursor, connection = db

    exam_date = exam_date.split("T")[0]
    
    cursor.execute("SELECT user_id FROM courses WHERE course_id = %s", (course_id,))
    course = cursor.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    user_id = course["user_id"]

    file_path = None
    if file and file.filename:
        os.makedirs(UPLOAD_DIR, exist_ok=True)
        file_path = os.path.join(UPLOAD_DIR, file.filename)
        with open(file_path, "wb") as buffer:
            buffer.write(file.file.read())

        file_path = f"/uploads/{file.filename}"
    elif external_link:
        file_path = external_link

    query = """INSERT INTO exams (course_id, title, description, exam_date, duration_minutes, file_path, user_id) 
               VALUES (%s, %s, %s, %s, %s, %s, %s)"""
    cursor.execute(query, (course_id, title, description, exam_date, duration_minutes, file_path, user_id))
    connection.commit()

    exam_id = cursor.lastrowid
    return {
        "exam_id": exam_id,
        "title": title,
        "description": description,
        "exam_date": exam_date,
        "duration_minutes": duration_minutes,
        "file_path": file_path, 
        "user_id": user_id
    }

@router.get("/exams/exams/{course_id}")
async def get_exams(course_id: int, db=Depends(get_db)):
    cursor, _ = db

    
    cursor.execute("SELECT course_name FROM courses WHERE course_id = %s", (course_id,))
    course = cursor.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    course_name = course["course_name"]

    cursor.execute("""
        SELECT e.exam_id, e.title, e.description, e.exam_date, e.duration_minutes, e.file_path, u.name AS instructor_name 
        FROM exams e
        JOIN users u ON e.user_id = u.user_id
        WHERE e.course_id = %s
    """, (course_id,))

    exams = cursor.fetchall()

    return {
        "course_name": course_name,
        "exams": [
            {
                "exam_id": e["exam_id"],
                "title": e["title"],
                "description": e["description"],
                "exam_date": str(e["exam_date"]).split(" ")[0],
                "duration_minutes": e["duration_minutes"],
                "file_path": e["file_path"],  
                "instructor_name": e["instructor_name"]
            }
            for e in exams
        ]
    }

@router.get("/exams/item/{exam_id}")
async def get_exam(exam_id: int, db=Depends(get_db)):
    cursor, _ = db
    query = "SELECT exam_id, title, description, exam_date, duration_minutes, file_path FROM exams WHERE exam_id = %s"
    cursor.execute(query, (exam_id,))
    exam = cursor.fetchone()

    if not exam:
        raise HTTPException(status_code=404, detail="Exam not found")

    return {
        "exam_id": exam["exam_id"],
        "title": exam["title"],
        "description": exam["description"],
        "exam_date": str(exam["exam_date"]).split(" ")[0],
        "duration_minutes": exam["duration_minutes"],
        "file_path": exam["file_path"]
    }

@router.get("/exams/download/{file_name}")
async def download_file(file_name: str):
    file_name = os.path.basename(file_name)  
    file_path = os.path.join(UPLOAD_DIR, file_name)

    if os.path.exists(file_path):
        return FileResponse(file_path, headers={"Content-Disposition": f"attachment; filename={file_name}"})
    
    raise HTTPException(status_code=404, detail="File not found")

@router.put("/exams/{exam_id}")
async def update_exam(
    exam_id: int,
    title: str = Form(...),
    description: str = Form(...),
    exam_date: str = Form(...),
    duration_minutes: int = Form(...),
    file: UploadFile = File(None),
    external_link: str = Form(None),
    db=Depends(get_db)
):
    cursor, connection = db
    
    # Check if exam exists
    cursor.execute("SELECT * FROM exams WHERE exam_id = %s", (exam_id,))
    existing_exam = cursor.fetchone()
    if not existing_exam:
        raise HTTPException(status_code=404, detail="Exam not found")
    
    exam_date = exam_date.split("T")[0]
    
    # Handle file upload or external link
    file_path = existing_exam["file_path"]  # Default to existing file path
    
    if file and file.filename:
        # Upload new file
        os.makedirs(UPLOAD_DIR, exist_ok=True)
        file_path = os.path.join(UPLOAD_DIR, file.filename)
        with open(file_path, "wb") as buffer:
            buffer.write(file.file.read())
        file_path = f"/uploads/{file.filename}"
    elif external_link:
        # Use external link
        file_path = external_link
    
    query = """UPDATE exams 
               SET title = %s, description = %s, exam_date = %s, duration_minutes = %s, file_path = %s 
               WHERE exam_id = %s"""
    cursor.execute(query, (title, description, exam_date, duration_minutes, file_path, exam_id))
    connection.commit()

    if cursor.rowcount == 0:
        raise HTTPException(status_code=404, detail="Exam not found")
    
    return {
        "message": "Exam updated successfully",
        "exam_id": exam_id,
        "title": title,
        "description": description,
        "exam_date": exam_date,
        "duration_minutes": duration_minutes,
        "file_path": file_path
    }

@router.delete("/exams/{exam_id}")
async def delete_exam(exam_id: int, db=Depends(get_db)):
    cursor, connection = db
    query = "DELETE FROM exams WHERE exam_id = %s"
    cursor.execute(query, (exam_id,))
    connection.commit()
    if cursor.rowcount == 0:
        raise HTTPException(status_code=404, detail="Exam not found")
    return {"message": "Exam deleted successfully"}
