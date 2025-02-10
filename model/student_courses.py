# model/student_courses.py
from fastapi import Depends, HTTPException, APIRouter
from pydantic import BaseModel
from .db import get_db

router = APIRouter()

class StudentCourseEnroll(BaseModel):
    student_id: int
    course_id: int

@router.post("/student_courses/")
async def enroll_student(enrollment: StudentCourseEnroll, db=Depends(get_db)):
    query = "INSERT INTO student_courses (student_id, course_id) VALUES (%s, %s)"
    db.execute(query, (enrollment.student_id, enrollment.course_id))
    db.connection.commit()
    return {"message": "Student enrolled successfully"}

@router.get("/student_courses/{student_id}")
async def get_student_courses(student_id: int, db=Depends(get_db)):
    query = "SELECT course_id FROM student_courses WHERE student_id = %s"
    db.execute(query, (student_id,))
    return db.fetchall()
