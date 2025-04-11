from fastapi import Depends, HTTPException, APIRouter
from pydantic import BaseModel
from .db import get_db
from typing import Optional
from datetime import datetime

router = APIRouter()

# ✅ Pydantic Models
class StudentResponse(BaseModel):
    student_id: int
    user_id: int  # This should be the user_id from the 'students' table
    name: str
    enrollment_date: Optional[str]
    degree: Optional[str] = None

    class Config:
        orm_mode = True

class CourseAssignRequest(BaseModel):
    course_id: int
    student_id: int


# ✅ Get all students
@router.get("/students/")
async def get_students(db_dep=Depends(get_db)):
    db, conn = db_dep
    db.execute("""
        SELECT user_id AS user_id, name, email
        FROM users WHERE role = 'student'""")
    students = db.fetchall()
    return students

# ✅ Get student by ID (linked to users)
@router.get("/students/{user_id}", response_model=StudentResponse)
async def get_student(user_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep
    try:
        db.execute("""
            SELECT s.student_id, s.user_id, CONCAT(s.first_name, ' ', s.last_name) AS name, 
                   u.email, s.enrollment_date, s.degree
            FROM students s
            JOIN users u ON s.user_id = u.user_id
            WHERE s.user_id = %s""", (user_id,))
        student = db.fetchone()
        if not student:
            raise HTTPException(status_code=404, detail="Student not found")

        # Convert enrollment_date to string
        if student['enrollment_date']:
            student['enrollment_date'] = student['enrollment_date'].strftime("%Y-%m-%d")

        return student
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")
    finally:
        # Ensure we fetch any remaining results before closing
        try:
            while db.fetchone():
                pass
        except:
            pass



# ✅ Delete student
@router.delete("/students/{student_id}")
async def delete_student(student_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep
    
    db.execute("DELETE FROM students WHERE student_id = %s", (student_id,))
    conn.commit()
    
    return {"message": "Student deleted successfully"}
