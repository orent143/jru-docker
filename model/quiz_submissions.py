# model/quiz_submissions.py
from fastapi import Depends, HTTPException, APIRouter
from pydantic import BaseModel
from .db import get_db

router = APIRouter()

class QuizSubmissionCreate(BaseModel):
    quiz_id: int
    student_id: int
    answers: str  # JSON-encoded answers
    submission_date: str

@router.post("/quiz_submissions/")
async def submit_quiz(submission: QuizSubmissionCreate, db=Depends(get_db)):
    query = "INSERT INTO quiz_submissions (quiz_id, student_id, answers, submission_date) VALUES (%s, %s, %s, %s)"
    db.execute(query, (submission.quiz_id, submission.student_id, submission.answers, submission.submission_date))
    db.connection.commit()
    return {"message": "Quiz submitted successfully"}

@router.get("/quiz_submissions/{quiz_id}")
async def get_quiz_submissions(quiz_id: int, db=Depends(get_db)):
    query = "SELECT id, student_id, answers, submission_date FROM quiz_submissions WHERE quiz_id = %s"
    db.execute(query, (quiz_id,))
    return db.fetchall()
