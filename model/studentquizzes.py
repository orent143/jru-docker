from fastapi import APIRouter, Depends, HTTPException, Form, File, UploadFile
from pydantic import BaseModel
from fastapi.responses import JSONResponse, FileResponse
import os
import uuid
from .db import get_db

UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)

router = APIRouter()

class QuizSubmission(BaseModel):
    student_id: int
    quiz_id: int
    file_path: str = None  
    submission_text: str = None  

class StudentQuiz(BaseModel):
    student_id: int
    course_id: int
    title: str
    description: str
    quiz_date: str
    file_path: str = None

class QuizFeedback(BaseModel):
    grade: float  
    feedback: str = None  
    
@router.post("/quizzes/")
async def create_quiz(
    course_id: int = Form(...),
    title: str = Form(...),
    description: str = Form(...),
    quiz_date: str = Form(...),
    file: UploadFile = File(None),
    external_link: str = Form(None),
    db_dep=Depends(get_db)
):
    db, conn = db_dep

    db.execute("SELECT course_name FROM courses WHERE course_id = %s", (course_id,))
    course = db.fetchone()
    if not course:
        raise HTTPException(status_code=400, detail="Course not found")
    
    file_path = None
    if file and file.filename:
        unique_filename = f"{uuid.uuid4()}_{file.filename}"
        file_path = os.path.join(UPLOAD_DIR, unique_filename)
        try:
            with open(file_path, "wb") as f:
                f.write(await file.read())
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Failed to save file: {str(e)}")
    elif external_link:
        file_path = external_link  # Store external link directly in file_path
    
    query = """
        INSERT INTO quizzes (course_id, title, description, quiz_date, file_path)
        VALUES (%s, %s, %s, %s, %s)
        RETURNING quiz_id
    """
    db.execute(query, (course_id, title, description, quiz_date, file_path))
    quiz_id = db.fetchone()["quiz_id"]
    conn.commit()

    return {
        "message": "Quiz created successfully", 
        "quiz_id": quiz_id, 
        "course_name": course["course_name"],
        "file_path": file_path
    }

@router.get("/quizzes/{course_id}")
async def get_course_quizzes(course_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT course_name FROM courses WHERE course_id = %s", (course_id,))
    course = db.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    query = """
        SELECT quiz_id, title, description, quiz_date, file_path 
        FROM quizzes
        WHERE course_id = %s ORDER BY quiz_date ASC
    """
    db.execute(query, (course_id,))
    quizzes = db.fetchall()

    return {"course_id": course_id, "course_name": course["course_name"], "quizzes": quizzes}

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
        SELECT quiz_id, title, description, quiz_date, file_path
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

@router.post("/submit-quiz/")
async def submit_quiz(
    student_id: int = Form(...), 
    quiz_id: int = Form(...),    
    file: UploadFile = File(None),  
    external_link: str = Form(None),  
    submission_text: str = Form(None), 
    db_dep=Depends(get_db) 
):
    """Handle quiz submission."""
    db, conn = db_dep
    file_path = None

    if file and file.filename:
        unique_filename = f"{uuid.uuid4()}_{file.filename}"
        file_path = os.path.join(UPLOAD_DIR, unique_filename)
        try:
            with open(file_path, "wb") as f:
                f.write(await file.read())
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Failed to save file: {str(e)}")

    elif external_link:
        file_path = external_link  # Store external link directly in file_path

    if not file_path and not submission_text:
        raise HTTPException(status_code=400, detail="Either a file/link or submission text must be provided")

    # Check if quiz exists and store result
    db.execute("SELECT * FROM quizzes WHERE quiz_id = %s", (quiz_id,))
    quiz = db.fetchone()
    if not quiz:
        raise HTTPException(status_code=404, detail="Quiz not found")

    # Check if student is enrolled and store result
    db.execute("SELECT * FROM student_courses WHERE student_id = %s", (student_id,))
    enrollment = db.fetchall()  # Fetch all records to ensure cursor is cleared
    if not enrollment:
        raise HTTPException(status_code=403, detail="Student is not enrolled in this course")

    # Check if the student has already submitted this quiz
    db.execute("SELECT submission_id FROM quiz_submissions WHERE quiz_id = %s AND student_id = %s", (quiz_id, student_id))
    existing_submission = db.fetchone()
    if existing_submission:
        # Delete the existing submission if it exists
        db.execute("DELETE FROM quiz_submissions WHERE submission_id = %s", (existing_submission["submission_id"],))
        conn.commit()

    query = """
        INSERT INTO quiz_submissions (quiz_id, student_id, file_path, submission_text)
        VALUES (%s, %s, %s, %s)
    """
    try:
        db.execute(query, (quiz_id, student_id, file_path, submission_text))
        conn.commit()
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

    return JSONResponse(
        content={"message": "Quiz submitted successfully", "file_path": file_path}, 
        status_code=200
    )

@router.get("/student_quiz_submissions/{student_id}")
async def get_student_quiz_submissions(student_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT * FROM students WHERE student_id = %s", (student_id,))
    student = db.fetchone()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")

    db.execute("""
        SELECT qs.quiz_id, q.title, qs.file_path, qs.submission_text, qs.submitted_at
        FROM quiz_submissions qs
        JOIN quizzes q ON qs.quiz_id = q.quiz_id
        WHERE qs.student_id = %s
        ORDER BY qs.submitted_at DESC
    """, (student_id,))
    submissions = db.fetchall()

    if not submissions:
        raise HTTPException(status_code=404, detail="No quiz submissions found for this student")

    return {
        "student_id": student_id,
        "submissions": submissions
    }

@router.get("/quiz_submissions/{quiz_id}")
async def get_submitted_quizzes(quiz_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep  

    db.execute("SELECT * FROM quizzes WHERE quiz_id = %s", (quiz_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Quiz not found")

    query = """
        SELECT qs.submission_id, qs.quiz_id, qs.student_id, u.name AS student_name, 
               qs.submitted_at, qs.file_path, qs.submission_text,
               qs.grade, qs.feedback
        FROM quiz_submissions qs
        JOIN users u ON qs.student_id = u.user_id
        WHERE qs.quiz_id = %s
        ORDER BY qs.submitted_at DESC
    """
    db.execute(query, (quiz_id,))
    submissions = db.fetchall()

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
               qs.file_path, qs.submission_text, qs.submitted_at,
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
    grade: float = Form(...),
    feedback: str = Form(None),
    db_dep=Depends(get_db)
):
    db, conn = db_dep

    db.execute("SELECT * FROM quiz_submissions WHERE submission_id = %s", (submission_id,))
    submission = db.fetchone()
    if not submission:
        raise HTTPException(status_code=404, detail="Quiz submission not found")

    query = """
        UPDATE quiz_submissions
        SET grade = %s, feedback = %s
        WHERE submission_id = %s
    """
    try:
        db.execute(query, (grade, feedback, submission_id))
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

    db.execute("SELECT * FROM quizzes WHERE quiz_id = %s", (quiz_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Quiz not found")

    db.execute("SELECT * FROM users WHERE user_id = %s", (student_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Student not found")

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

    db.execute("SELECT * FROM quiz_submissions WHERE submission_id = %s", (submission_id,))
    submission = db.fetchone()
    if not submission:
        raise HTTPException(status_code=404, detail="Quiz submission not found")

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

@router.get("/quizzes/download/{file_name}")
async def download_quiz_file(file_name: str):
    file_name = os.path.basename(file_name)  
    file_path = os.path.join(UPLOAD_DIR, file_name)

    if os.path.exists(file_path):
        return FileResponse(file_path, headers={"Content-Disposition": f"attachment; filename={file_name}"})
    
    raise HTTPException(status_code=404, detail="File not found")
