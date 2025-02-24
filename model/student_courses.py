from fastapi import Depends, HTTPException, APIRouter
from pydantic import BaseModel
from .db import get_db

router = APIRouter()

class StudentCourseEnroll(BaseModel):
    user_id: int
    course_id: int

# ✅ Enroll Student in a Course
@router.post("/student_courses/")
async def enroll_student(enrollment: StudentCourseEnroll, db_dep=Depends(get_db)):
    db, conn = db_dep

    # Check if user exists
    db.execute("SELECT user_id FROM users WHERE user_id = %s AND role = 'student'", (enrollment.user_id,))
    if not db.fetchone():
        raise HTTPException(status_code=400, detail="Student not found")

    # Check if course exists
    db.execute("SELECT course_id FROM courses WHERE course_id = %s", (enrollment.course_id,))
    if not db.fetchone():
        raise HTTPException(status_code=400, detail="Course not found")

    # Prevent duplicate enrollment
    db.execute("SELECT * FROM student_courses WHERE student_id = %s AND course_id = %s",
               (enrollment.user_id, enrollment.course_id))
    if db.fetchone():
        raise HTTPException(status_code=400, detail="Student is already enrolled in this course")

    # Insert enrollment
    query = "INSERT INTO student_courses (student_id, course_id) VALUES (%s, %s)"
    db.execute(query, (enrollment.user_id, enrollment.course_id))
    conn.commit()

    return {"message": "Student enrolled successfully"}

# ✅ Get Students Enrolled in a Course
@router.get("/course_students/{course_id}")
async def get_students_in_course(course_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    # Check if course exists
    db.execute("SELECT course_id FROM courses WHERE course_id = %s", (course_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Course not found")

    # Fetch enrolled students
    query = """
        SELECT s.student_id, s.user_id, s.first_name, s.last_name
        FROM student_courses sc
        JOIN users s ON sc.student_id = s.user_id
        WHERE sc.course_id = %s
    """
    db.execute(query, (course_id,))
    students = db.fetchall()

    return {"course_id": course_id, "students": students}

# ✅ Get Courses a Student is Enrolled In
@router.get("/student_courses/{student_id}")
async def get_student_courses(student_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    # Ensure student exists
    db.execute("SELECT user_id FROM users WHERE user_id = %s AND role = 'student'", (student_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Student not found")

    # Fetch courses linked to the student
    query = """
        SELECT c.course_id, c.course_name, c.section, c.class_schedule
        FROM student_courses sc
        JOIN courses c ON sc.course_id = c.course_id
        WHERE sc.student_id = %s
    """
    db.execute(query, (student_id,))
    courses = db.fetchall()

    return {"student_id": student_id, "courses": courses}

# ✅ Get Course Content for an Enrolled Student
@router.get("/student_course_content/{student_id}/{course_id}")
async def get_student_course_content(student_id: int, course_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    # Check if student exists
    db.execute("SELECT user_id FROM users WHERE user_id = %s AND role = 'student'", (student_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Student not found")

    # Check if student is enrolled in the course
    db.execute("SELECT * FROM student_courses WHERE student_id = %s AND course_id = %s", (student_id, course_id))
    if not db.fetchone():
        raise HTTPException(status_code=403, detail="Student is not enrolled in this course")

    # Fetch course details
    db.execute("SELECT course_name FROM courses WHERE course_id = %s", (course_id,))
    course = db.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    # Fetch course content
    query = """
        SELECT content_id, title, content AS description, file_path, created_at
        FROM course_content
        WHERE course_id = %s
        ORDER BY created_at DESC
    """
    db.execute(query, (course_id,))
    course_content = db.fetchall()

    return {
        "student_id": student_id,
        "course_id": course_id,
        "course": course,  # ✅ Ensuring course details are returned
        "content": course_content
    }

@router.get("/course_materials/{course_id}")
async def get_course_materials(course_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    # Check if course exists
    db.execute("SELECT course_id, course_name FROM courses WHERE course_id = %s", (course_id,))
    course = db.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    # Fetch course materials
    query = """
        SELECT content_id, title, content AS description, file_path, created_at
        FROM course_content
        WHERE course_id = %s
        ORDER BY created_at DESC
    """
    db.execute(query, (course_id,))
    course_materials = db.fetchall()

    return {
        "course_id": course_id,
        "course_name": course["course_name"],
        "materials": course_materials
    }