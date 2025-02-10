# model/exams.py
from fastapi import Depends, HTTPException, APIRouter
from pydantic import BaseModel
from .db import get_db

router = APIRouter()

class ExamCreate(BaseModel):
    course_id: int
    title: str
    exam_date: str
    duration_minutes: int

@router.post("/exams/")
async def create_exam(exam: ExamCreate, db=Depends(get_db)):
    query = "INSERT INTO exams (course_id, title, exam_date, duration_minutes) VALUES (%s, %s, %s, %s)"
    db.execute(query, (exam.course_id, exam.title, exam.exam_date, exam.duration_minutes))
    db.connection.commit()
    return {"message": "Exam created successfully"}

@router.get("/exams/{course_id}")
async def get_exams(course_id: int, db=Depends(get_db)):
    query = "SELECT id, title, exam_date, duration_minutes FROM exams WHERE course_id = %s"
    db.execute(query, (course_id,))
    return db.fetchall()
