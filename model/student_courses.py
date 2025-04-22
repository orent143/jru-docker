from fastapi import Depends, HTTPException, APIRouter
from pydantic import BaseModel
from .db import get_db

router = APIRouter()

class StudentCourseEnroll(BaseModel):
    user_id: int
    course_id: int

@router.post("/student_courses/")
async def enroll_student(enrollment: StudentCourseEnroll, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT user_id FROM users WHERE user_id = %s AND role = 'student'", (enrollment.user_id,))
    if not db.fetchone():
        raise HTTPException(status_code=400, detail="Student not found")

    db.execute("SELECT course_id FROM courses WHERE course_id = %s", (enrollment.course_id,))
    if not db.fetchone():
        raise HTTPException(status_code=400, detail="Course not found")

    db.execute("SELECT * FROM student_courses WHERE student_id = %s AND course_id = %s",
               (enrollment.user_id, enrollment.course_id))
    if db.fetchone():
        raise HTTPException(status_code=400, detail="Student is already enrolled in this course")

    query = "INSERT INTO student_courses (student_id, course_id) VALUES (%s, %s)"
    db.execute(query, (enrollment.user_id, enrollment.course_id))
    conn.commit()

    return {"message": "Student enrolled successfully"}

@router.get("/course_students/{course_id}")
async def get_students_in_course(course_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT course_id FROM courses WHERE course_id = %s", (course_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Course not found")

    query = """
        SELECT s.student_id, s.user_id, CONCAT(s.first_name, ' ', s.last_name) AS name
        FROM student_courses sc
        JOIN users s ON sc.student_id = s.user_id
        WHERE sc.course_id = %s
    """
    db.execute(query, (course_id,))
    students = db.fetchall()

    return {"course_id": course_id, "students": students}

@router.get("/student_courses/{student_id}")
async def get_student_courses(student_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT user_id FROM users WHERE user_id = %s AND role = 'student'", (student_id,))
    if not db.fetchone():
        return {"student_id": student_id, "courses": []}

    query = """
        SELECT c.course_id, c.course_name, c.section, c.class_schedule
        FROM student_courses sc
        JOIN courses c ON sc.course_id = c.course_id
        WHERE sc.student_id = %s
    """
    db.execute(query, (student_id,))
    courses = db.fetchall()

    return {"student_id": student_id, "courses": courses}

@router.get("/student_course_content/{student_id}/{course_id}")
async def get_student_course_content(student_id: int, course_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT user_id FROM users WHERE user_id = %s AND role = 'student'", (student_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Student not found")

    db.execute("SELECT * FROM student_courses WHERE student_id = %s AND course_id = %s", (student_id, course_id))
    if not db.fetchone():
        raise HTTPException(status_code=403, detail="Student is not enrolled in this course")

    db.execute("SELECT course_name FROM courses WHERE course_id = %s", (course_id,))
    course = db.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

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
        "course": course,  
        "content": course_content
    }

@router.get("/course_materials/{course_id}")
async def get_course_materials(course_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT course_id, course_name FROM courses WHERE course_id = %s", (course_id,))
    course = db.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

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

@router.delete("/student_courses/{student_id}/{course_id}")
async def remove_student_from_course(student_id: int, course_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT user_id FROM users WHERE user_id = %s AND role = 'student'", (student_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Student not found")

    db.execute("SELECT course_id FROM courses WHERE course_id = %s", (course_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Course not found")

    db.execute("SELECT * FROM student_courses WHERE student_id = %s AND course_id = %s", (student_id, course_id))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Student is not enrolled in this course")

    db.execute("DELETE FROM student_courses WHERE student_id = %s AND course_id = %s", (student_id, course_id))
    conn.commit()

    return {"message": "Student removed from course successfully"}