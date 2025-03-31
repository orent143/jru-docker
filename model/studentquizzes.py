from fastapi import Depends, HTTPException, APIRouter
from pydantic import BaseModel
from .db import get_db

router = APIRouter()

class StudentQuiz(BaseModel):
    student_id: int
    course_id: int
    title: str
    description: str
    quiz_date: str
    external_link: str = None

class QuizSubmission(BaseModel):
    student_id: int
    quiz_id: int
    answers: dict

# ✅ Create a Quiz for a Course
@router.post("/quizzes/")
async def create_quiz(quiz: StudentQuiz, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT course_name FROM courses WHERE course_id = %s", (quiz.course_id,))
    course = db.fetchone()
    if not course:
        raise HTTPException(status_code=400, detail="Course not found")
    
    query = """
        INSERT INTO quizzes (course_id, title, description, quiz_date, external_link)
        VALUES (%s, %s, %s, %s, %s)
        RETURNING quiz_id
    """
    db.execute(query, (quiz.course_id, quiz.title, quiz.description, quiz.quiz_date, quiz.external_link))
    quiz_id = db.fetchone()["quiz_id"]
    conn.commit()

    return {"message": "Quiz created successfully", "quiz_id": quiz_id, "course_name": course["course_name"]}

# ✅ Get Quizzes for a Course
@router.get("/quizzes/{course_id}")
async def get_course_quizzes(course_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT course_name FROM courses WHERE course_id = %s", (course_id,))
    course = db.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    query = """
        SELECT quiz_id, title, description, quiz_date, external_link 
        FROM quizzes
        WHERE course_id = %s ORDER BY quiz_date ASC
    """
    db.execute(query, (course_id,))
    quizzes = db.fetchall()

    return {"course_id": course_id, "course_name": course["course_name"], "quizzes": quizzes}

# ✅ Get Quizzes for a Specific Student
@router.get("/student_quizzes/{student_id}/{course_id}")
async def get_student_quizzes(student_id: int, course_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT * FROM student_courses WHERE student_id = %s AND course_id = %s", (student_id, course_id))
    if not db.fetchone():
        raise HTTPException(status_code=403, detail="Student is not enrolled in this course")

    db.execute("SELECT course_name FROM courses WHERE course_id = %s", (course_id,))
    course = db.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    query = """
        SELECT quiz_id, title, description, quiz_date, external_link
        FROM quizzes
        WHERE course_id = %s
        ORDER BY quiz_date ASC
    """
    db.execute(query, (course_id,))
    quizzes = db.fetchall()

    return {
        "student_id": student_id, 
        "course_id": course_id, 
        "course_name": course["course_name"], 
        "quizzes": quizzes
    }

# ✅ Submit a Quiz
@router.post("/quiz_submissions/")
async def submit_quiz(submission: QuizSubmission, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT * FROM quizzes WHERE quiz_id = %s", (submission.quiz_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Quiz not found")

    db.execute("SELECT * FROM student_courses WHERE student_id = %s", (submission.student_id,))
    if not db.fetchone():
        raise HTTPException(status_code=403, detail="Student is not enrolled in this course")

    query = """
        INSERT INTO quiz_submissions (quiz_id, student_id, answers)
        VALUES (%s, %s, %s)
    """
    db.execute(query, (submission.quiz_id, submission.student_id, str(submission.answers)))
    conn.commit()

    return {"message": "Quiz submitted successfully"}

# ✅ Get Submitted Quiz Responses
@router.get("/quiz_submissions/{quiz_id}")
async def get_quiz_submissions(quiz_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT course_id FROM quizzes WHERE quiz_id = %s", (quiz_id,))
    quiz = db.fetchone()
    if not quiz:
        raise HTTPException(status_code=404, detail="Quiz not found")
    
    db.execute("SELECT course_name FROM courses WHERE course_id = %s", (quiz["course_id"],))
    course = db.fetchone()
    
    query = """
        SELECT student_id, score, submitted_at FROM quiz_submissions WHERE quiz_id = %s
    """
    db.execute(query, (quiz_id,))
    submissions = db.fetchall()

    return {"quiz_id": quiz_id, "course_name": course["course_name"], "submissions": submissions}
