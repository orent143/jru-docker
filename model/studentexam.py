from fastapi import Depends, HTTPException, APIRouter, Form, UploadFile, File
from fastapi.responses import JSONResponse, FileResponse
from pydantic import BaseModel
from .db import get_db
import os
import uuid

router = APIRouter()

# Directory for uploaded files
UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)  # Ensure the directory exists

# ✅ Schema for student exams
class StudentExam(BaseModel):
    student_id: int
    course_id: int
    title: str
    description: str
    exam_date: str

class ExamSubmission(BaseModel):
    student_id: int
    exam_id: int
    answers: dict
    file: UploadFile = None  # Allow optional file submission
    external_link: str = None  # Allow optional external link submission

class ExamFeedback(BaseModel):
    grade: float  # The grade (can be a float or an integer)
    feedback: str = None  # Optional feedback
    
# ✅ Create an Exam for a Course (with file upload and external link)
@router.post("/exams/")
async def create_exam(
    course_id: int = Form(...),
    title: str = Form(...),
    description: str = Form(...),
    exam_date: str = Form(...),
    file: UploadFile = File(None),
    external_link: str = Form(None),
    db_dep=Depends(get_db)
):
    db, conn = db_dep

    # Ensure course exists
    db.execute("SELECT course_id FROM courses WHERE course_id = %s", (course_id,))
    if not db.fetchone():
        raise HTTPException(status_code=400, detail="Course not found")

    # Handle file upload or external link
    file_path = None
    if file:
        file_path = os.path.join(UPLOAD_DIR, file.filename)
        with open(file_path, "wb") as buffer:
            buffer.write(file.file.read())
        file_path = f"/exams/download/{file.filename}"

    # Insert the exam with file or link
    query = """
        INSERT INTO exams (course_id, title, description, exam_date, file_path, external_link)
        VALUES (%s, %s, %s, %s, %s, %s)
        RETURNING exam_id
    """
    db.execute(query, (course_id, title, description, exam_date, file_path, external_link))
    exam_id = db.fetchone()["exam_id"]
    conn.commit()

    return {
        "message": "Exam created successfully",
        "exam_id": exam_id,
        "file_path": file_path,
        "external_link": external_link
    }

@router.get("/exams/{course_id}")
async def get_course_exams(course_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    # Ensure course exists
    db.execute("SELECT course_id FROM courses WHERE course_id = %s", (course_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Course not found")

    query = """
        SELECT exam_id, title, description, exam_date, file_path, external_link 
        FROM exams
        WHERE course_id = %s 
        ORDER BY exam_date ASC
    """
    db.execute(query, (course_id,))
    exams = db.fetchall()

    # Add clickable links or download URLs
    for exam in exams:
        if exam["file_path"]:
            exam["file_url"] = exam["file_path"]
        if exam["external_link"]:
            exam["external_link"] = exam["external_link"]

    return {"course_id": course_id, "exams": exams}


@router.get("/student_exams/{student_id}/{course_id}")
async def get_student_exams(student_id: int, course_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    # Ensure student is enrolled
    db.execute("SELECT * FROM student_courses WHERE student_id = %s AND course_id = %s", (student_id, course_id))
    if not db.fetchone():
        raise HTTPException(status_code=403, detail="Student is not enrolled in this course")

    # Fetch exams with file links and external links
    query = """
        SELECT exam_id, title, description, exam_date, file_path, external_link
        FROM exams
        WHERE course_id = %s
        ORDER BY exam_date ASC
    """
    db.execute(query, (course_id,))
    exams = db.fetchall()

    # Add file download URLs or clickable external links
    results = []
    for exam in exams:
        file_url = None
        external_link = None

        if exam["file_path"]:
            file_url = exam["file_path"]  # File download link
        if exam["external_link"]:
            external_link = exam["external_link"]  # Clickable external link

        results.append({
            "exam_id": exam["exam_id"],
            "title": exam["title"],
            "description": exam["description"],
            "exam_date": exam["exam_date"],
            "file_url": file_url,
            "external_link": external_link
        })

    return {
        "student_id": student_id,
        "course_id": course_id,
        "exams": results
    }

# ✅ Download file
@router.get("/exams/download/{file_name}")
async def download_exam_file(file_name: str):
    file_name = os.path.basename(file_name)  # Sanitize file name
    file_path = os.path.join(UPLOAD_DIR, file_name)

    if os.path.exists(file_path):
        return FileResponse(file_path, headers={"Content-Disposition": f"attachment; filename={file_name}"})
    
    raise HTTPException(status_code=404, detail="File not found")

@router.post("/submit-exam/")
async def submit_exam(
    student_id: int = Form(...),          # Expecting Form data for student_id
    exam_id: int = Form(...),             # Expecting Form data for exam_id
    submission_text: str = Form(None),    # Optional submission text
    file: UploadFile = File(None),        # File data, sent as multipart form data
    external_link: str = Form(None),      # External link, sent as Form data
    db_dep=Depends(get_db)               # Inject the db dependency here
):
    """Handle exam submission."""
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

    # Check if the exam exists
    db.execute("SELECT * FROM exams WHERE exam_id = %s", (exam_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Exam not found")

    # Check if the student is enrolled in the course
    db.execute("SELECT * FROM student_courses WHERE student_id = %s", (student_id,))
    if not db.fetchone():
        raise HTTPException(status_code=403, detail="Student is not enrolled in this course")

    # Insert exam submission into the database
    query = """
        INSERT INTO exam_submissions (exam_id, student_id, file_path, external_link, submission_text)
        VALUES (%s, %s, %s, %s, %s)
    """
    try:
        db.execute(query, (exam_id, student_id, file_path, external_link, submission_text))
        conn.commit()
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

    return JSONResponse(
        content={"message": "Exam submitted successfully", "file_path": file_path, "external_link": external_link}, 
        status_code=200
    )
    
@router.get("/exam-submissions/{exam_id}")
async def get_exam_submissions(exam_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    query = """
        SELECT es.submission_id, es.exam_id, es.student_id, u.name AS student_name, 
               es.file_path, es.external_link, es.submission_text, es.submitted_at,
               es.grade, es.feedback
        FROM exam_submissions es
        JOIN users u ON es.student_id = u.user_id
        WHERE es.exam_id = %s
        ORDER BY es.submitted_at DESC
    """
    db.execute(query, (exam_id,))
    submissions = db.fetchall()

    return {"exam_id": exam_id, "submissions": submissions}

@router.get("/exam-submission/{submission_id}")
async def get_exam_submission(submission_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    query = """
        SELECT es.submission_id, es.exam_id, es.student_id, u.name AS student_name, 
               es.file_path, es.external_link, es.submission_text, es.submitted_at,
               es.grade, es.feedback
        FROM exam_submissions es
        JOIN users u ON es.student_id = u.user_id
        WHERE es.submission_id = %s
    """
    db.execute(query, (submission_id,))
    submission = db.fetchone()

    if not submission:
        raise HTTPException(status_code=404, detail="Exam submission not found")

    return submission

@router.put("/exam-submission/{submission_id}/grade")
async def update_exam_submission_grade(
    submission_id: int,
    feedback: ExamFeedback,
    db_dep=Depends(get_db)
):
    db, conn = db_dep

    # Check if the exam submission exists
    db.execute("SELECT * FROM exam_submissions WHERE submission_id = %s", (submission_id,))
    submission = db.fetchone()
    if not submission:
        raise HTTPException(status_code=404, detail="Exam submission not found")

    # Update the grade and feedback
    query = """
        UPDATE exam_submissions
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