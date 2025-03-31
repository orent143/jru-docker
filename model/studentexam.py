from fastapi import Depends, HTTPException, APIRouter, Form, UploadFile, File
from fastapi.responses import FileResponse
from pydantic import BaseModel
from .db import get_db
import os

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

# ✅ Schema for exam submission
class ExamSubmission(BaseModel):
    student_id: int
    exam_id: int
    answers: dict

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

# ✅ Get Exams for a Course (Faculty View)
@router.get("/exams/{course_id}")
async def get_course_exams(course_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

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

# ✅ Get Exams for a Specific Student (with file downloads and external links)
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
async def download_file(file_name: str):
    file_name = os.path.basename(file_name)  # Sanitize file name
    file_path = os.path.join(UPLOAD_DIR, file_name)

    if os.path.exists(file_path):
        return FileResponse(file_path, headers={"Content-Disposition": f"attachment; filename={file_name}"})
    
    raise HTTPException(status_code=404, detail="File not found")

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

    query = """
        SELECT student_id, score, submitted_at 
        FROM exam_submissions 
        WHERE exam_id = %s
    """
    db.execute(query, (exam_id,))
    submissions = db.fetchall()

    return {"exam_id": exam_id, "submissions": submissions}
