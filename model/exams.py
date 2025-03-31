from fastapi import Depends, HTTPException, APIRouter, Form, File, UploadFile, FastAPI
from pydantic import BaseModel
import os
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles
from .db import get_db

router = APIRouter()

# Directory for uploaded files
UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)  # Ensure the directory exists

# Serve static files (uploaded files) in the 'uploads' directory
app = FastAPI()  # FastAPI app is created here
app.mount("/uploads", StaticFiles(directory=UPLOAD_DIR), name="uploads")

# ✅ Schema
class ExamCreate(BaseModel):
    course_id: int
    title: str
    description: str
    exam_date: str
    duration_minutes: int
    external_link: str = None  # Optionally accept an external link

class ExamUpdate(BaseModel):
    title: str
    description: str
    exam_date: str
    duration_minutes: int
    external_link: str = None  # Optionally accept an external link

# ✅ Create Exam
@router.post("/exams")
async def create_exam(
    course_id: int = Form(...),
    title: str = Form(...),
    description: str = Form(...),
    exam_date: str = Form(...),
    duration_minutes: int = Form(...),
    file: UploadFile = File(None),
    external_link: str = Form(None),  # Accept external link
    db=Depends(get_db)
):
    cursor, connection = db

    # Ensure course exists
    cursor.execute("SELECT user_id FROM courses WHERE course_id = %s", (course_id,))
    course = cursor.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    user_id = course["user_id"]

    # Handle file upload if no external link is provided
    file_url = None
    if file:
        os.makedirs(UPLOAD_DIR, exist_ok=True)
        file_path = os.path.join(UPLOAD_DIR, file.filename)
        with open(file_path, "wb") as buffer:
            buffer.write(file.file.read())

        # Store relative path for the file
        file_url = f"/uploads/{file.filename}"
    elif external_link:
        # If an external link is provided, use it instead of file upload
        file_url = external_link

    # Insert exam record into the database
    query = """INSERT INTO exams (course_id, title, description, exam_date, duration_minutes, file_path, user_id) 
               VALUES (%s, %s, %s, %s, %s, %s, %s)"""
    cursor.execute(query, (course_id, title, description, exam_date, duration_minutes, file_url, user_id))
    connection.commit()

    exam_id = cursor.lastrowid
    return {
        "exam_id": exam_id,
        "title": title,
        "description": description,
        "exam_date": exam_date,
        "duration_minutes": duration_minutes,
        "file_path": file_url,  # Return file URL (either local or external)
        "user_id": user_id
    }

# ✅ Get Exams for a Course
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
                "exam_date": e["exam_date"],
                "duration_minutes": e["duration_minutes"],
                "file_path": e["file_path"],  # Return the file path (either local or external)
                "instructor_name": e["instructor_name"]
            }
            for e in exams
        ]
    }

# ✅ Get Single Exam (with file download link)
@router.get("/exams/item/{exam_id}")
async def get_exam(exam_id: int, db=Depends(get_db)):
    cursor, _ = db
    query = "SELECT exam_id, title, description, exam_date, duration_minutes, file_path FROM exams WHERE exam_id = %s"
    cursor.execute(query, (exam_id,))
    exam = cursor.fetchone()

    if not exam:
        raise HTTPException(status_code=404, detail="Exam not found")

    file_url = exam["file_path"] if exam["file_path"] else None

    return {
        "exam_id": exam["exam_id"],
        "title": exam["title"],
        "description": exam["description"],
        "exam_date": exam["exam_date"],
        "duration_minutes": exam["duration_minutes"],
        "file_path": file_url
    }
@router.get("/exams/download/{file_name}")
async def download_file(file_name: str):
    file_name = os.path.basename(file_name)  # To avoid directory traversal attacks
    file_path = os.path.join(UPLOAD_DIR, file_name)

    # Check if the file exists in the uploads directory
    if os.path.exists(file_path):
        return FileResponse(file_path, headers={"Content-Disposition": f"attachment; filename={file_name}"})
    
    raise HTTPException(status_code=404, detail="File not found")

# ✅ Update Exam
@router.put("/exams/{exam_id}")
async def update_exam(exam_id: int, exam: ExamUpdate, db=Depends(get_db)):
    cursor, connection = db
    query = """UPDATE exams 
               SET title = %s, description = %s, exam_date = %s, duration_minutes = %s, file_path = %s 
               WHERE exam_id = %s"""
    cursor.execute(query, (exam.title, exam.description, exam.exam_date, exam.duration_minutes, exam.external_link, exam_id))
    connection.commit()
    if cursor.rowcount == 0:
        raise HTTPException(status_code=404, detail="Exam not found")
    return {"message": "Exam updated successfully"}

# ✅ Delete Exam
@router.delete("/exams/{exam_id}")
async def delete_exam(exam_id: int, db=Depends(get_db)):
    cursor, connection = db
    query = "DELETE FROM exams WHERE exam_id = %s"
    cursor.execute(query, (exam_id,))
    connection.commit()
    if cursor.rowcount == 0:
        raise HTTPException(status_code=404, detail="Exam not found")
    return {"message": "Exam deleted successfully"}
