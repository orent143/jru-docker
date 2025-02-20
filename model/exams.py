from fastapi import Depends, HTTPException, APIRouter, Path, Form, File, UploadFile
from pydantic import BaseModel
import os
from .db import get_db

router = APIRouter()

UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)  # Ensure the directory exists

# ✅ Schema
class ExamCreate(BaseModel):
    course_id: int
    title: str
    description: str
    exam_date: str
    duration_minutes: int

class ExamUpdate(BaseModel):
    title: str
    description: str
    exam_date: str
    duration_minutes: int

@router.post("/exams")
async def create_exam(
    course_id: int = Form(...),
    title: str = Form(...),
    description: str = Form(...),
    exam_date: str = Form(...),
    duration_minutes: int = Form(...),
    file: UploadFile = File(None),
    db=Depends(get_db)
):
    cursor, connection = db

    # Ensure course exists
    cursor.execute("SELECT user_id FROM courses WHERE course_id = %s", (course_id,))
    course = cursor.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    user_id = course["user_id"]

    # Handle file upload
    file_path = None
    if file:
        os.makedirs(UPLOAD_DIR, exist_ok=True)
        file_path = os.path.join(UPLOAD_DIR, file.filename)
        with open(file_path, "wb") as buffer:
            buffer.write(file.file.read())

    # Insert into database
    query = "INSERT INTO exams (course_id, title, description, exam_date, duration_minutes, file_path, user_id) VALUES (%s, %s, %s, %s, %s, %s, %s)"
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

# ✅ READ (GET)
@router.get("/exams/{course_id}")
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
                "file_path": e["file_path"],
                "instructor_name": e["instructor_name"]
            }
            for e in exams
        ]
    }

# ✅ GET SINGLE EXAM
@router.get("/exams/item/{exam_id}")
async def get_exam(exam_id: int, db=Depends(get_db)):
    cursor, _ = db
    query = "SELECT exam_id, title, description, exam_date, duration_minutes FROM exams WHERE exam_id = %s"
    cursor.execute(query, (exam_id,))
    exam = cursor.fetchone()

    if not exam:
        raise HTTPException(status_code=404, detail="Exam not found")

    return {
        "exam_id": exam["exam_id"],
        "title": exam["title"],
        "description": exam["description"],
        "exam_date": exam["exam_date"],
        "duration_minutes": exam["duration_minutes"]
    }

# ✅ UPDATE (PUT)
@router.put("/exams/{exam_id}")
async def update_exam(exam_id: int, exam: ExamUpdate, db=Depends(get_db)):
    cursor, connection = db
    query = "UPDATE exams SET title = %s, description = %s, exam_date = %s, duration_minutes = %s WHERE exam_id = %s"
    cursor.execute(query, (exam.title, exam.description, exam.exam_date, exam.duration_minutes, exam_id))
    connection.commit()
    if cursor.rowcount == 0:
        raise HTTPException(status_code=404, detail="Exam not found")
    return {"message": "Exam updated successfully"}

# ✅ DELETE (DELETE)
@router.delete("/exams/{exam_id}")
async def delete_exam(exam_id: int, db=Depends(get_db)):
    cursor, connection = db
    query = "DELETE FROM exams WHERE exam_id = %s"
    cursor.execute(query, (exam_id,))
    connection.commit()
    if cursor.rowcount == 0:
        raise HTTPException(status_code=404, detail="Exam not found")
    return {"message": "Exam deleted successfully"}
