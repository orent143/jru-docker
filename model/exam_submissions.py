# model/exam_submissions.py
from fastapi import Depends, HTTPException, APIRouter
from pydantic import BaseModel
from .db import get_db

router = APIRouter()

class ExamSubmissionCreate(BaseModel):
    exam_id: int
    student_id: int
    answers: str  # JSON-encoded answers
    submission_date: str

@router.post("/exam_submissions/")
async def submit_exam(submission: ExamSubmissionCreate, db=Depends(get_db)):
    query = "INSERT INTO exam_submissions (exam_id, student_id, answers, submission_date) VALUES (%s, %s, %s, %s)"
    db.execute(query, (submission.exam_id, submission.student_id, submission.answers, submission.submission_date))
    db.connection.commit()
    return {"message": "Exam submitted successfully"}

@router.get("/exam_submissions/{exam_id}")
async def get_exam_submissions(exam_id: int, db=Depends(get_db)):
    query = "SELECT id, student_id, answers, submission_date FROM exam_submissions WHERE exam_id = %s"
    db.execute(query, (exam_id,))
    return db.fetchall()
