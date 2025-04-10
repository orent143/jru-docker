from fastapi import APIRouter, Depends, HTTPException, Form, File, UploadFile
from pydantic import BaseModel
from fastapi.responses import JSONResponse
import os
import uuid
from .db import get_db

UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)

router = APIRouter()

class QuizSubmission(BaseModel):
    student_id: int
    quiz_id: int
    file_path: str = None  # File data or external link
    external_link: str = None
    submission_text: str = None  # Optional text submission

class StudentQuiz(BaseModel):
    student_id: int
    course_id: int
    title: str
    description: str
    quiz_date: str
    external_link: str = None

class QuizFeedback(BaseModel):
    grade: float  # The grade (can be a float or an integer)
    feedback: str = None  # Optional feedback
    
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
@router.post("/submit-quiz/")
async def submit_quiz(
    student_id: int = Form(...),  # Expecting Form data for student_id
    quiz_id: int = Form(...),     # Expecting Form data for quiz_id
    file: UploadFile = File(None),  # Optional file data sent as multipart form data
    external_link: str = Form(None),  # External link submitted via Form data
    submission_text: str = Form(None),  # Optional text submission
    db_dep=Depends(get_db)  # Inject the db dependency
):
    """Handle quiz submission."""
    db, conn = db_dep
    file_path = None

    # Process file upload if provided
    if file and file.filename:
        unique_filename = f"{uuid.uuid4()}_{file.filename}"
        file_path = os.path.join(UPLOAD_DIR, unique_filename)
        try:
            with open(file_path, "wb") as f:
                f.write(await file.read())
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Failed to save file: {str(e)}")

    # If external link provided, use it
    elif external_link:
        file_path = external_link

    # Ensure either file or external link is provided
    if not file_path:
        raise HTTPException(status_code=400, detail="Either a file or an external link must be provided")

    # Check if the quiz exists
    db.execute("SELECT * FROM quizzes WHERE quiz_id = %s", (quiz_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Quiz not found")

    # Check if the student is enrolled in the course
    db.execute("SELECT * FROM student_courses WHERE student_id = %s", (student_id,))
    if not db.fetchone():
        raise HTTPException(status_code=403, detail="Student is not enrolled in this course")

    # Insert quiz submission into the database
    query = """
        INSERT INTO quiz_submissions (quiz_id, student_id, file_path, external_link, submission_text)
        VALUES (%s, %s, %s, %s, %s)
    """
    try:
        db.execute(query, (quiz_id, student_id, file_path, external_link, submission_text))
        conn.commit()
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

    return JSONResponse(
        content={"message": "Quiz submitted successfully", "file_path": file_path, "external_link": external_link}, 
        status_code=200
    )

@router.get("/student_quiz_submissions/{student_id}")
async def get_student_quiz_submissions(student_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    # Check if the student exists
    db.execute("SELECT * FROM students WHERE student_id = %s", (student_id,))
    student = db.fetchone()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")

    # Get all quiz submissions for the student
    db.execute("""
        SELECT qs.quiz_id, q.title, qs.file_path, qs.submission_text, qs.submitted_at
        FROM quiz_submissions qs
        JOIN quizzes q ON qs.quiz_id = q.quiz_id
        WHERE qs.student_id = %s
        ORDER BY qs.submitted_at DESC
    """, (student_id,))
    submissions = db.fetchall()

    # If no submissions found
    if not submissions:
        raise HTTPException(status_code=404, detail="No quiz submissions found for this student")

    return {
        "student_id": student_id,
        "submissions": submissions
    }

@router.get("/quiz_submissions/{quiz_id}")
async def get_submitted_quizzes(quiz_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep  # Unpack the tuple returned by get_db()

    # Check if the quiz exists
    db.execute("SELECT * FROM quizzes WHERE quiz_id = %s", (quiz_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Quiz not found")

    query = """
        SELECT qs.submission_id, qs.quiz_id, qs.student_id, u.name AS student_name, 
               qs.submitted_at, qs.file_path, qs.external_link, qs.submission_text,
               qs.grade, qs.feedback
        FROM quiz_submissions qs
        JOIN users u ON qs.student_id = u.user_id
        WHERE qs.quiz_id = %s
        ORDER BY qs.submitted_at DESC
    """
    db.execute(query, (quiz_id,))
    submissions = db.fetchall()

    # If no submissions found
    if not submissions:
        raise HTTPException(status_code=404, detail="No submissions found for this quiz")

    return {
        "quiz_id": quiz_id,
        "submissions": submissions
    }

@router.get("/quiz-submission/{submission_id}")
async def get_quiz_submission(submission_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    query = """
        SELECT qs.submission_id, qs.quiz_id, qs.student_id, u.name AS student_name,
               qs.file_path, qs.external_link, qs.submission_text, qs.submitted_at,
               qs.grade, qs.feedback
        FROM quiz_submissions qs
        JOIN users u ON qs.student_id = u.user_id
        WHERE qs.submission_id = %s
    """
    db.execute(query, (submission_id,))
    submission = db.fetchone()

    if not submission:
        raise HTTPException(status_code=404, detail="Quiz submission not found")

    return submission

@router.put("/quiz-submission/{submission_id}/grade")
async def update_quiz_submission_grade(
    submission_id: int,
    feedback: QuizFeedback,
    db_dep=Depends(get_db)
):
    db, conn = db_dep

    # Check if the submission exists
    db.execute("SELECT * FROM quiz_submissions WHERE submission_id = %s", (submission_id,))
    submission = db.fetchone()
    if not submission:
        raise HTTPException(status_code=404, detail="Quiz submission not found")

    # Update the grade and feedback
    query = """
        UPDATE quiz_submissions
        SET grade = %s, feedback = %s
        WHERE submission_id = %s
    """
    try:
        db.execute(query, (feedback.grade, feedback.feedback, submission_id))
        conn.commit()
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

    return JSONResponse(
        content={"message": "Grade and feedback updated successfully"},
        status_code=200
    )

@router.get("/quiz-submission/{quiz_id}/{student_id}")
async def get_quiz_submission_id(quiz_id: int, student_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    # Check if the quiz exists
    db.execute("SELECT * FROM quizzes WHERE quiz_id = %s", (quiz_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Quiz not found")

    # Check if the student exists
    db.execute("SELECT * FROM users WHERE user_id = %s", (student_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Student not found")

    # Get the submission ID
    query = """
        SELECT submission_id
        FROM quiz_submissions
        WHERE quiz_id = %s AND student_id = %s
    """
    db.execute(query, (quiz_id, student_id))
    submission = db.fetchone()

    if not submission:
        raise HTTPException(status_code=404, detail="No submission found for this quiz and student")

    return {"submission_id": submission["submission_id"]}

@router.delete("/quiz-submission/{submission_id}")
async def delete_quiz_submission(submission_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    # Check if the submission exists
    db.execute("SELECT * FROM quiz_submissions WHERE submission_id = %s", (submission_id,))
    submission = db.fetchone()
    if not submission:
        raise HTTPException(status_code=404, detail="Quiz submission not found")

    # Delete the submission
    query = "DELETE FROM quiz_submissions WHERE submission_id = %s"
    try:
        db.execute(query, (submission_id,))
        conn.commit()
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

    return JSONResponse(
        content={"message": "Quiz submission deleted successfully"},
        status_code=200
    )
