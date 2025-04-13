from fastapi import Depends, HTTPException, APIRouter, Form, UploadFile, File
from fastapi.responses import JSONResponse, FileResponse
from pydantic import BaseModel
from .db import get_db
import os
import uuid

router = APIRouter()

UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True) 

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
    file: UploadFile = None  
    external_link: str = None  

class ExamFeedback(BaseModel):
    grade: float 
    feedback: str = None  
    
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

    db.execute("SELECT course_id FROM courses WHERE course_id = %s", (course_id,))
    if not db.fetchone():
        raise HTTPException(status_code=400, detail="Course not found")

    file_path = None
    if file and file.filename:
        unique_filename = f"{uuid.uuid4()}_{file.filename}"
        file_path = os.path.join(UPLOAD_DIR, unique_filename)
        with open(file_path, "wb") as buffer:
            buffer.write(await file.read())
        file_path = f"/exams/download/{unique_filename}"
    elif external_link:
        file_path = external_link

    query = """
        INSERT INTO exams (course_id, title, description, exam_date, file_path)
        VALUES (%s, %s, %s, %s, %s)
        RETURNING exam_id
    """
    db.execute(query, (course_id, title, description, exam_date, file_path))
    exam_id = db.fetchone()["exam_id"]
    conn.commit()

    return {
        "message": "Exam created successfully",
        "exam_id": exam_id,
        "file_path": file_path
    }

@router.get("/exams/{course_id}")
async def get_course_exams(course_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT course_id FROM courses WHERE course_id = %s", (course_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Course not found")

    query = """
        SELECT exam_id, title, description, exam_date, file_path 
        FROM exams
        WHERE course_id = %s 
        ORDER BY exam_date ASC
    """
    db.execute(query, (course_id,))
    exams = db.fetchall()

    return {"course_id": course_id, "exams": exams}


@router.get("/student_exams/{student_id}/{course_id}")
async def get_student_exams(student_id: int, course_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT * FROM student_courses WHERE student_id = %s AND course_id = %s", (student_id, course_id))
    if not db.fetchone():
        raise HTTPException(status_code=403, detail="Student is not enrolled in this course")

    query = """
        SELECT exam_id, title, description, exam_date, file_path
        FROM exams
        WHERE course_id = %s
        ORDER BY exam_date ASC
    """
    db.execute(query, (course_id,))
    exams = db.fetchall()

    return {
        "student_id": student_id,
        "course_id": course_id,
        "exams": exams
    }

@router.get("/exams/download/{file_name}")
async def download_exam_file(file_name: str):
    file_name = os.path.basename(file_name)  
    file_path = os.path.join(UPLOAD_DIR, file_name)

    if os.path.exists(file_path):
        return FileResponse(file_path, headers={"Content-Disposition": f"attachment; filename={file_name}"})
    
    raise HTTPException(status_code=404, detail="File not found")

@router.post("/submit-exam/")
async def submit_exam(
    student_id: int = Form(...),        
    exam_id: int = Form(...),            
    submission_text: str = Form(None),   
    file: UploadFile = File(None),       
    external_link: str = Form(None),    
    db_dep=Depends(get_db)               
):
    """Handle exam submission."""
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
        file_path = external_link

    if not file_path and not submission_text:
        raise HTTPException(status_code=400, detail="Either a file/link or submission text must be provided")

    # Check if exam exists and store result
    db.execute("SELECT * FROM exams WHERE exam_id = %s", (exam_id,))
    exam = db.fetchone()
    if not exam:
        raise HTTPException(status_code=404, detail="Exam not found")

    # Check if student is enrolled and store result
    db.execute("SELECT * FROM student_courses WHERE student_id = %s AND course_id = %s", 
              (student_id, exam['course_id']))
    enrollment = db.fetchall()  # Fetch all records to ensure cursor is cleared
    if not enrollment:
        raise HTTPException(status_code=403, detail="Student is not enrolled in this course")
    
    # Check if the student has already submitted this exam
    db.execute("SELECT submission_id FROM exam_submissions WHERE student_id = %s AND exam_id = %s", (student_id, exam_id))
    existing_submission = db.fetchone()
    if existing_submission:
        # Delete the existing submission if it exists
        db.execute("DELETE FROM exam_submissions WHERE submission_id = %s", (existing_submission["submission_id"],))
        conn.commit()

    query = """
        INSERT INTO exam_submissions (exam_id, student_id, file_path, submission_text)
        VALUES (%s, %s, %s, %s)
    """
    try:
        db.execute(query, (exam_id, student_id, file_path, submission_text))
        conn.commit()
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

    return JSONResponse(
        content={"message": "Exam submitted successfully", "file_path": file_path}, 
        status_code=200
    )

@router.get("/exam-submissions/{exam_id}")
async def get_exam_submissions(exam_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    query = """
        SELECT es.submission_id, es.exam_id, es.student_id, u.name AS student_name, 
               es.file_path, es.submission_text, es.submitted_at,
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
               es.file_path, es.submission_text, es.submitted_at,
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

@router.get("/exam-submission/{exam_id}/{student_id}")
async def get_student_exam_submission(exam_id: int, student_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    query = """
        SELECT es.submission_id, es.exam_id, es.student_id, u.name AS student_name, 
               es.file_path, es.submission_text, es.submitted_at,
               es.grade, es.feedback
        FROM exam_submissions es
        JOIN users u ON es.student_id = u.user_id
        WHERE es.exam_id = %s AND es.student_id = %s
    """
    db.execute(query, (exam_id, student_id))
    submission = db.fetchone()

    if not submission:
        raise HTTPException(status_code=404, detail="Exam submission not found")

    return submission

@router.delete("/exam-submission/{submission_id}")
async def delete_exam_submission(submission_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep
    
    db.execute("SELECT * FROM exam_submissions WHERE submission_id = %s", (submission_id,))
    submission = db.fetchone()
    
    if not submission:
        raise HTTPException(status_code=404, detail="Exam submission not found")
    
    query = "DELETE FROM exam_submissions WHERE submission_id = %s"
    try:
        db.execute(query, (submission_id,))
        conn.commit()
        
        return JSONResponse(
            content={"message": "Exam submission deleted successfully"},
            status_code=200
        )
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

@router.put("/exam-submission/{submission_id}/grade")
async def update_exam_submission_grade(
    submission_id: int,
    grade: float = Form(...),
    feedback: str = Form(None),
    db_dep=Depends(get_db)
):
    db, conn = db_dep

    db.execute("SELECT * FROM exam_submissions WHERE submission_id = %s", (submission_id,))
    submission = db.fetchone()
    if not submission:
        raise HTTPException(status_code=404, detail="Exam submission not found")

    query = """
        UPDATE exam_submissions
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