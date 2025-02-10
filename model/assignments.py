# model/assignments.py
from fastapi import Depends, HTTPException, APIRouter
from pydantic import BaseModel
from .db import get_db

router = APIRouter()

class AssignmentCreate(BaseModel):
    course_id: int
    title: str
    description: str
    due_date: str

@router.post("/assignments/")
async def create_assignment(assignment: AssignmentCreate, db=Depends(get_db)):
    query = "INSERT INTO assignments (course_id, title, description, due_date) VALUES (%s, %s, %s, %s)"
    db.execute(query, (assignment.course_id, assignment.title, assignment.description, assignment.due_date))
    db.connection.commit()
    return {"message": "Assignment created successfully"}

@router.get("/assignments/{course_id}")
async def get_assignments(course_id: int, db=Depends(get_db)):
    query = "SELECT id, title, description, due_date FROM assignments WHERE course_id = %s"
    db.execute(query, (course_id,))
    return db.fetchall()
