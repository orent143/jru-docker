# model/quizzes.py
from fastapi import Depends, HTTPException, APIRouter
from pydantic import BaseModel
from .db import get_db

router = APIRouter()

class QuizCreate(BaseModel):
    course_id: int
    title: str
    quiz_date: str

@router.post("/quizzes/")
async def create_quiz(quiz: QuizCreate, db=Depends(get_db)):
    query = "INSERT INTO quizzes (course_id, title, quiz_date) VALUES (%s, %s, %s)"
    db.execute(query, (quiz.course_id, quiz.title, quiz.quiz_date))
    db.connection.commit()
    return {"message": "Quiz created successfully"}

@router.get("/quizzes/{course_id}")
async def get_quizzes(course_id: int, db=Depends(get_db)):
    query = "SELECT id, title, quiz_date FROM quizzes WHERE course_id = %s"
    db.execute(query, (course_id,))
    return db.fetchall()
