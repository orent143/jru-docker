# model/students.py
from fastapi import Depends, HTTPException, APIRouter
from .db import get_db

router = APIRouter()

@router.get("/students/")
async def get_students(db=Depends(get_db)):
    db.execute("SELECT student_id, user_id, first_name, last_name, enrollment_date FROM students")
    students = [{"student_id": s[0], "user_id": s[1], "first_name": s[2], "last_name": s[3], "enrollment_date": s[4]} for s in db.fetchall()]
    return students

@router.get("/students/{student_id}")
async def get_student(student_id: int, db=Depends(get_db)):
    db.execute("SELECT student_id, user_id, first_name, last_name, enrollment_date FROM students WHERE student_id = %s", (student_id,))
    student = db.fetchone()
    if student:
        return {"student_id": student[0], "user_id": student[1], "first_name": student[2], "last_name": student[3], "enrollment_date": student[4]}
    raise HTTPException(status_code=404, detail="Student not found")

@router.post("/students/")
async def create_student(user_id: int, first_name: str, last_name: str, db=Depends(get_db)):
    db.execute("INSERT INTO students (user_id, first_name, last_name) VALUES (%s, %s, %s)", (user_id, first_name, last_name))
    db.connection.commit()
    return {"message": "Student created successfully"}

@router.delete("/students/{student_id}")
async def delete_student(student_id: int, db=Depends(get_db)):
    db.execute("DELETE FROM students WHERE student_id = %s", (student_id,))
    db.connection.commit()
    return {"message": "Student deleted successfully"}
