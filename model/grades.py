# model/grades.py
from fastapi import Depends, HTTPException, APIRouter
from pydantic import BaseModel
from .db import get_db

router = APIRouter()

class GradeCreate(BaseModel):
    student_id: int
    course_id: int
    grade: float

@router.post("/grades/")
async def assign_grade(grade: GradeCreate, db=Depends(get_db)):
    query = "INSERT INTO grades (student_id, course_id, grade) VALUES (%s, %s, %s)"
    db.execute(query, (grade.student_id, grade.course_id, grade.grade))
    db.connection.commit()
    return {"message": "Grade assigned successfully"}

@router.get("/grades/{student_id}")
async def get_student_grades(student_id: int, db=Depends(get_db)):
    query = "SELECT course_id, grade FROM grades WHERE student_id = %s"
    db.execute(query, (student_id,))
    return db.fetchall()
