from fastapi import FastAPI, Depends, HTTPException, APIRouter, Form, File, UploadFile
from pydantic import BaseModel
import os
from .db import get_db
from fastapi.responses import JSONResponse

# Create FastAPI app instance
app = FastAPI()

# Router for quiz-related operations
router = APIRouter()

# ✅ Schema
class QuizCreate(BaseModel):
    course_id: int
    title: str
    description: str
    quiz_date: str
    duration_minutes: int
    external_link: str = None  # New field for the external link

class QuizUpdate(BaseModel):
    title: str
    description: str
    quiz_date: str
    duration_minutes: int
    external_link: str = None  # New field for the external link

# ✅ CREATE QUIZ (POST)
@router.post("/quizzes")
async def create_quiz(
    course_id: int = Form(...),
    title: str = Form(...),
    description: str = Form(...),
    quiz_date: str = Form(...),
    duration_minutes: int = Form(...),
    external_link: str = Form(None),  # Accept external link as a form field
    db=Depends(get_db)
):
    cursor, connection = db

    # Ensure course exists
    cursor.execute("SELECT user_id FROM courses WHERE course_id = %s", (course_id,))
    course = cursor.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    user_id = course["user_id"]

    # Insert into database without file_path
    query = """
    INSERT INTO quizzes (course_id, title, description, quiz_date, duration_minutes, external_link, user_id)
    VALUES (%s, %s, %s, %s, %s, %s, %s)
    """
    cursor.execute(query, (course_id, title, description, quiz_date, duration_minutes, external_link, user_id))
    connection.commit()

    quiz_id = cursor.lastrowid

    return {
        "quiz_id": quiz_id,
        "title": title,
        "description": description,
        "quiz_date": quiz_date,
        "duration_minutes": duration_minutes,
        "external_link": external_link,  # Return the external link
        "user_id": user_id
    }

@router.get("/quizzes/quizzes/{course_id}")
async def get_quizzes(course_id: int, db=Depends(get_db)):
    cursor, _ = db

    cursor.execute("SELECT course_name FROM courses WHERE course_id = %s", (course_id,))
    course = cursor.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    course_name = course["course_name"]

    cursor.execute("""
        SELECT q.quiz_id, q.title, q.description, q.quiz_date, q.duration_minutes, q.external_link, u.name AS instructor_name
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
                "external_link": q["external_link"],  # Include the external link in the response
                "instructor_name": q["instructor_name"]
            }
            for q in quizzes
        ]
    }


@router.get("/quizzes/item/{quiz_id}")
async def get_quiz(quiz_id: int, db=Depends(get_db)):
    cursor, _ = db
    query = "SELECT quiz_id, title, description, quiz_date, duration_minutes, external_link FROM quizzes WHERE quiz_id = %s"
    cursor.execute(query, (quiz_id,))
    quiz = cursor.fetchone()

    if not quiz:
        raise HTTPException(status_code=404, detail="Quiz not found")

    return {
        "quiz_id": quiz["quiz_id"],
        "title": quiz["title"],
        "description": quiz["description"],
        "quiz_date": quiz["quiz_date"],
        "duration_minutes": quiz["duration_minutes"],
        "external_link": quiz["external_link"]  # Return the external link
    }

# ✅ UPDATE (PUT)
@router.put("/quizzes/{quiz_id}")
async def update_quiz(quiz_id: int, quiz: QuizUpdate, db=Depends(get_db)):
    cursor, connection = db
    query = """
    UPDATE quizzes 
    SET title = %s, description = %s, quiz_date = %s, duration_minutes = %s, external_link = %s
    WHERE quiz_id = %s
    """
    cursor.execute(query, (quiz.title, quiz.description, quiz.quiz_date, quiz.duration_minutes, quiz.external_link, quiz_id))
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

# Include the router in the app
app.include_router(router)


