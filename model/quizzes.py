from fastapi import Depends, HTTPException, APIRouter, Path, Form, File, UploadFile
from pydantic import BaseModel
import os
from .db import get_db

router = APIRouter()

UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)  # Ensure the directory exists

# ✅ Schema
class QuizCreate(BaseModel):
    course_id: int
    title: str
    description: str
    quiz_date: str
    duration_minutes: int

class QuizUpdate(BaseModel):
    title: str
    description: str
    quiz_date: str
    duration_minutes: int

@router.post("/quizzes")
async def create_quiz(
    course_id: int = Form(...),
    title: str = Form(...),
    description: str = Form(...),
    quiz_date: str = Form(...),
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
    query = "INSERT INTO quizzes (course_id, title, description, quiz_date, duration_minutes, file_path, user_id) VALUES (%s, %s, %s, %s, %s, %s, %s)"
    cursor.execute(query, (course_id, title, description, quiz_date, duration_minutes, file_path, user_id))
    connection.commit()

    quiz_id = cursor.lastrowid
    return {
        "quiz_id": quiz_id,
        "title": title,
        "description": description,
        "quiz_date": quiz_date,
        "duration_minutes": duration_minutes,
        "file_path": file_path,
        "user_id": user_id
    }

# ✅ READ (GET)
@router.get("/quizzes/{course_id}")
async def get_quizzes(course_id: int, db=Depends(get_db)):
    cursor, _ = db

    cursor.execute("SELECT course_name FROM courses WHERE course_id = %s", (course_id,))
    course = cursor.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    course_name = course["course_name"]

    cursor.execute("""
        SELECT q.quiz_id, q.title, q.description, q.quiz_date, q.duration_minutes, q.file_path, u.name AS instructor_name 
        FROM quizzes q
        JOIN users u ON q.user_id = u.user_id
        WHERE q.course_id = %s
    """, (course_id,))

    quizzes = cursor.fetchall()

    return {
        "course_name": course_name,
        "quizzes": [
            {
                "quiz_id": q["quiz_id"],
                "title": q["title"],
                "description": q["description"],
                "quiz_date": q["quiz_date"],
                "duration_minutes": q["duration_minutes"],
                "file_path": q["file_path"],
                "instructor_name": q["instructor_name"]
            }
            for q in quizzes
        ]
    }

# ✅ GET SINGLE QUIZ
@router.get("/quizzes/item/{quiz_id}")
async def get_quiz(quiz_id: int, db=Depends(get_db)):
    cursor, _ = db
    query = "SELECT quiz_id, title, description, quiz_date, duration_minutes FROM quizzes WHERE quiz_id = %s"
    cursor.execute(query, (quiz_id,))
    quiz = cursor.fetchone()

    if not quiz:
        raise HTTPException(status_code=404, detail="Quiz not found")

    return {
        "quiz_id": quiz["quiz_id"],
        "title": quiz["title"],
        "description": quiz["description"],
        "quiz_date": quiz["quiz_date"],
        "duration_minutes": quiz["duration_minutes"]
    }

# ✅ UPDATE (PUT)
@router.put("/quizzes/{quiz_id}")
async def update_quiz(quiz_id: int, quiz: QuizUpdate, db=Depends(get_db)):
    cursor, connection = db
    query = "UPDATE quizzes SET title = %s, description = %s, quiz_date = %s, duration_minutes = %s WHERE quiz_id = %s"
    cursor.execute(query, (quiz.title, quiz.description, quiz.quiz_date, quiz.duration_minutes, quiz_id))
    connection.commit()
    if cursor.rowcount == 0:
        raise HTTPException(status_code=404, detail="Quiz not found")
    return {"message": "Quiz updated successfully"}

# ✅ DELETE (DELETE)
@router.delete("/quizzes/{quiz_id}")
async def delete_quiz(quiz_id: int, db=Depends(get_db)):
    cursor, connection = db
    query = "DELETE FROM quizzes WHERE quiz_id = %s"
    cursor.execute(query, (quiz_id,))
    connection.commit()
    if cursor.rowcount == 0:
        raise HTTPException(status_code=404, detail="Quiz not found")
    return {"message": "Quiz deleted successfully"}
