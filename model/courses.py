from fastapi import Depends, HTTPException, APIRouter, Query
from pydantic import BaseModel
from .db import get_db
from typing import List, Dict

router = APIRouter()

# ✅ Schema
class CourseCreate(BaseModel):
    course_name: str
    section: str
    user_id: int  # Instructor ID
    class_schedule: str

class CourseResponse(BaseModel):
    course_id: int
    course_name: str
    section: str
    class_schedule: str
    user_id: int  # ✅ Ensure user_id is included

class CourseUpdate(BaseModel):
    course_name: str
    section: str
    class_schedule: str

# ✅ CREATE (POST)
@router.post("/courses/", response_model=CourseResponse)
async def create_course(course: CourseCreate, db=Depends(get_db)):
    cursor, connection = db
    
    # Ensure user exists
    cursor.execute("SELECT user_id FROM users WHERE user_id = %s", (course.user_id,))
    if not cursor.fetchone():
        raise HTTPException(status_code=404, detail="User not found")
    
    try:
        query = """
            INSERT INTO courses (course_name, section, user_id, class_schedule)
            VALUES (%s, %s, %s, %s)
        """
        cursor.execute(query, (course.course_name, course.section, course.user_id, course.class_schedule))
        connection.commit()
        course_id = cursor.lastrowid
        
        return CourseResponse(course_id=course_id, **course.dict())
    except Exception as e:
        connection.rollback()
        raise HTTPException(status_code=500, detail=f"Error inserting course: {str(e)}")

# ✅ READ ALL (GET)
@router.get("/courses/", response_model=List[CourseResponse])
async def read_courses(user_id: int = Query(...), db=Depends(get_db)):
    cursor, _ = db

    # Validate user role
    cursor.execute("SELECT role FROM users WHERE user_id = %s", (user_id,))
    user = cursor.fetchone()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    user_role = user[0] if isinstance(user, tuple) else user.get("role", "")
    
    if user_role not in ["faculty", "admin"]:
        raise HTTPException(status_code=403, detail="Access restricted to faculty or admin users")
    
    query = "SELECT course_id, course_name, section, class_schedule, user_id FROM courses WHERE user_id = %s"
    cursor.execute(query, (user_id,))
    courses = cursor.fetchall()
    
    return [dict(course) for course in courses]

# ✅ GET STUDENTS IN COURSE
@router.get("/course_students/{course_id}")
async def get_students_in_course(course_id: int, db=Depends(get_db)):
    cursor, _ = db

    cursor.execute("SELECT course_id FROM courses WHERE course_id = %s", (course_id,))
    if not cursor.fetchone():
        raise HTTPException(status_code=404, detail="Course not found")
    
    query = """
        SELECT u.user_id AS student_id, u.name, u.email
        FROM student_courses sc
        JOIN users u ON sc.student_id = u.user_id
        WHERE sc.course_id = %s AND u.role = 'student'
    """
    cursor.execute(query, (course_id,))
    students = cursor.fetchall()
    
    return {"course_id": course_id, "students": [dict(student) for student in students]}

# ✅ UPDATE (PUT)
@router.put("/courses/{course_id}")
async def update_course(course_id: int, course: CourseUpdate, user_id: int, db=Depends(get_db)):
    cursor, connection = db
    
    cursor.execute("SELECT user_id FROM courses WHERE course_id = %s", (course_id,))
    existing_course = cursor.fetchone()
    if not existing_course:
        raise HTTPException(status_code=404, detail="Course not found")
    
    if existing_course["user_id"] != user_id:
        raise HTTPException(status_code=403, detail="Unauthorized to update this course")
    
    query = "UPDATE courses SET course_name = %s, section = %s, class_schedule = %s WHERE course_id = %s"
    cursor.execute(query, (course.course_name, course.section, course.class_schedule, course_id))
    connection.commit()
    return {"message": "Course updated successfully"}

# ✅ DELETE (DELETE)
@router.delete("/courses/{course_id}")
async def delete_course(course_id: int, user_id: int, db=Depends(get_db)):
    cursor, connection = db
    
    cursor.execute("SELECT user_id FROM courses WHERE course_id = %s", (course_id,))
    existing_course = cursor.fetchone()
    if not existing_course:
        raise HTTPException(status_code=404, detail="Course not found")
    
    # Validate user role
    cursor.execute("SELECT role FROM users WHERE user_id = %s", (user_id,))
    user = cursor.fetchone()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    user_role = user[0] if isinstance(user, tuple) else user.get("role", "")
    
    if user_role not in ["faculty", "admin"]:
        raise HTTPException(status_code=403, detail="Unauthorized to delete course")
    
    cursor.execute("DELETE FROM courses WHERE course_id = %s", (course_id,))
    connection.commit()
    return {"message": "Course deleted successfully"}
