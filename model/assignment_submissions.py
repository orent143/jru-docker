# model/assignment_submissions.py
from fastapi import Depends, HTTPException, APIRouter
from pydantic import BaseModel
from .db import get_db

router = APIRouter()

class AssignmentSubmissionCreate(BaseModel):
    assignment_id: int
    student_id: int
    submission_text: str
    submission_date: str

@router.post("/assignment_submissions/")
async def submit_assignment(submission: AssignmentSubmissionCreate, db=Depends(get_db)):
    query = "INSERT INTO assignment_submissions (assignment_id, student_id, submission_text, submission_date) VALUES (%s, %s, %s, %s)"
    db.execute(query, (submission.assignment_id, submission.student_id, submission.submission_text, submission.submission_date))
    db.connection.commit()
    return {"message": "Assignment submitted successfully"}

@router.get("/assignment_submissions/{assignment_id}")
async def get_submissions(assignment_id: int, db=Depends(get_db)):
    query = "SELECT id, student_id, submission_text, submission_date FROM assignment_submissions WHERE assignment_id = %s"
    db.execute(query, (assignment_id,))
    return db.fetchall()
