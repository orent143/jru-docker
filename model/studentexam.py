from fastapi import Depends, HTTPException, APIRouter
from pydantic import BaseModel
from .db import get_db

router = APIRouter()

class StudentExam(BaseModel):
    student_id: int
    course_id: int
    title: str
    description: str
    exam_date: str  # Changed from quiz_date to exam_date


class ExamSubmission(BaseModel):
    student_id: int
    exam_id: int
    answers: dict  # Stores question_id as key and answer as value

# ✅ Create an Exam for a Course
@router.post("/exams/")
async def create_exam(exam: StudentExam, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT course_id FROM courses WHERE course_id = %s", (exam.course_id,))
    if not db.fetchone():
        raise HTTPException(status_code=400, detail="Course not found")
    
    query = """
        INSERT INTO exams (course_id, title, description, exam_date)
        VALUES (%s, %s, %s, %s)
        RETURNING exam_id
    """
    db.execute(query, (exam.course_id, exam.title, exam.description, exam.exam_date))
    exam_id = db.fetchone()["exam_id"]
    conn.commit()

    return {"message": "Exam created successfully", "exam_id": exam_id}

# ✅ Get Exams for a Course
@router.get("/exams/{course_id}")
async def get_course_exams(course_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT course_id FROM courses WHERE course_id = %s", (course_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Course not found")

    query = """
        SELECT exam_id, title, description, exam_date FROM exams
        WHERE course_id = %s ORDER BY exam_date ASC
    """
    db.execute(query, (course_id,))
    exams = db.fetchall()

    return {"course_id": course_id, "exams": exams}

# ✅ Get Exams for a Specific Student
@router.get("/student_exams/{student_id}/{course_id}")
async def get_student_exams(student_id: int, course_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT * FROM student_courses WHERE student_id = %s AND course_id = %s", (student_id, course_id))
    if not db.fetchone():
        raise HTTPException(status_code=403, detail="Student is not enrolled in this course")

    query = """
        SELECT exam_id, title, description, exam_date
        FROM exams
        WHERE course_id = %s
        ORDER BY exam_date ASC
    """
    db.execute(query, (course_id,))
    exams = db.fetchall()

    return {"student_id": student_id, "course_id": course_id, "exams": exams}

# ✅ Submit an Exam
@router.post("/exam_submissions/")
async def submit_exam(submission: ExamSubmission, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT * FROM exams WHERE exam_id = %s", (submission.exam_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Exam not found")

    db.execute("SELECT * FROM student_courses WHERE student_id = %s", (submission.student_id,))
    if not db.fetchone():
        raise HTTPException(status_code=403, detail="Student is not enrolled in this course")

    query = """
        INSERT INTO exam_submissions (exam_id, student_id, answers)
        VALUES (%s, %s, %s)
    """
    db.execute(query, (submission.exam_id, submission.student_id, str(submission.answers)))
    conn.commit()

    return {"message": "Exam submitted successfully"}

# ✅ Get Submitted Exam Responses
@router.get("/exam_submissions/{exam_id}")
async def get_exam_submissions(exam_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep  

    query = "SELECT student_id, score, submitted_at FROM exam_submissions WHERE exam_id = %s"
    db.execute(query, (exam_id,))
    submissions = db.fetchall()

    return {"exam_id": exam_id, "submissions": submissions}
