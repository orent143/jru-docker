from fastapi import APIRouter, Depends, HTTPException, File, UploadFile, FastAPI, Form
from pydantic import BaseModel
from fastapi.staticfiles import StaticFiles
from fastapi.responses import JSONResponse, FileResponse
import os
import uuid  
from .db import get_db

app = FastAPI()

UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)  
app.mount("/uploads", StaticFiles(directory=UPLOAD_DIR), name="uploads")

router = APIRouter()

class StudentAssignment(BaseModel):
    student_id: int
    course_id: int
    title: str
    description: str
    due_date: str

class AssignmentSubmission(BaseModel):
    student_id: int
    assignment_id: int
    file_path: str = None  
    submission_text: str
    
class AssignmentFeedback(BaseModel):
    grade: float  
    feedback: str = None  

@router.post("/submit-assignment/")
async def submit_assignment(
    student_id: int = Form(...),
    assignment_id: int = Form(...),
    file: UploadFile = File(None),
    external_link: str = Form(None),
    submission_text: str = Form(...),
    db_dep=Depends(get_db)
):
    """Handle assignment submission."""
    db, conn = db_dep
    file_path = None

    db.execute("SELECT * FROM assignment_submissions WHERE student_id = %s AND assignment_id = %s", (student_id, assignment_id))
    existing_submission = db.fetchone()
    if existing_submission:
        raise HTTPException(status_code=400, detail="Submission already exists for this assignment")

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

    if not file_path:
        raise HTTPException(status_code=400, detail="Either a file or an external link must be provided")

    # Only use file_path for both files and links
    query = """
        INSERT INTO assignment_submissions (student_id, assignment_id, file_path, submission_text)
        VALUES (%s, %s, %s, %s)
    """
    try:
        db.execute(query, (student_id, assignment_id, file_path, submission_text))
        conn.commit()
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

    return JSONResponse(
        content={"message": "Submission successful", "file_path": file_path}, 
        status_code=200
    )

@router.delete("/assignment-submission/{submission_id}")
async def delete_assignment_submission(submission_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT * FROM assignment_submissions WHERE submission_id = %s", (submission_id,))
    submission = db.fetchone()
    if not submission:
        raise HTTPException(status_code=404, detail="Assignment submission not found")

    query = "DELETE FROM assignment_submissions WHERE submission_id = %s"
    try:
        db.execute(query, (submission_id,))
        conn.commit()
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

    return JSONResponse(
        content={"message": "Submission deleted successfully"},
        status_code=200
    )

@router.get("/student-assignment/{course_id}")
async def get_course_assignments(course_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT course_name FROM courses WHERE course_id = %s", (course_id,))
    course = db.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    query = """
        SELECT assignment_id, title, description, due_date, file_path
        FROM assignments
        WHERE course_id = %s ORDER BY due_date ASC
    """
    db.execute(query, (course_id,))
    assignments = db.fetchall()

    return {
        "course_name": course["course_name"],
        "assignments": assignments
    }
    
@router.get("/student_assignments/{student_id}/{course_id}")
async def get_student_assignments(student_id: int, course_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT * FROM student_courses WHERE student_id = %s AND course_id = %s", (student_id, course_id))
    if not db.fetchone():
        raise HTTPException(status_code=403, detail="Student is not enrolled in this course")

    db.execute("SELECT course_name FROM courses WHERE course_id = %s", (course_id,))
    course = db.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    query = """
        SELECT assignment_id, title, description, due_date, file_path
        FROM assignments
        WHERE course_id = %s ORDER BY due_date ASC
    """
    db.execute(query, (course_id,))
    assignments = db.fetchall()

    result = []
    for assignment in assignments:
        result.append({
            "assignment_id": assignment["assignment_id"],
            "title": assignment["title"],
            "description": assignment["description"],
            "due_date": assignment["due_date"],
            "file_path": assignment["file_path"] if assignment["file_path"] else None
        })

    return {
        "student_id": student_id,
        "course_id": course_id,
        "course_name": course["course_name"],
        "assignments": result
    }

@router.get("/assignment_submissions/{assignment_id}")
async def get_submitted_assignments(assignment_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT * FROM assignments WHERE assignment_id = %s", (assignment_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Assignment not found")

    query = """
        SELECT asb.submission_id, asb.student_id, u.name AS student_name, 
               asb.file_path, asb.submission_text, asb.submitted_at,
               asb.grade, asb.feedback
        FROM assignment_submissions asb
        JOIN users u ON asb.student_id = u.user_id
        WHERE asb.assignment_id = %s
        ORDER BY asb.submitted_at DESC
    """
    db.execute(query, (assignment_id,))
    submissions = db.fetchall()

    return {
        "assignment_id": assignment_id,
        "submissions": submissions
    }

@router.get("/assignment_submissions/download/{file_name}")
async def download_submission_file(file_name: str):
    file_name = os.path.basename(file_name)  
    file_path = os.path.join(UPLOAD_DIR, file_name)

    if os.path.exists(file_path):
        return FileResponse(file_path, headers={"Content-Disposition": f"attachment; filename={file_name}"})
    
    raise HTTPException(status_code=404, detail="File not found")

@router.get("/assignments/download/{file_name}")
async def download_file(file_name: str):
    file_path = os.path.join(UPLOAD_DIR, file_name)
    if not os.path.isfile(file_path):
        raise HTTPException(status_code=404, detail="File not found")
    return FileResponse(path=file_path, filename=file_name)

@router.put("/assignment-submission/{submission_id}/grade")
async def update_assignment_submission_grade(
    submission_id: int,
    feedback: AssignmentFeedback,
    db_dep=Depends(get_db)
):
    db, conn = db_dep

    db.execute("SELECT * FROM assignment_submissions WHERE submission_id = %s", (submission_id,))
    submission = db.fetchone()
    if not submission:
        raise HTTPException(status_code=404, detail="Assignment submission not found")

    query = """
        UPDATE assignment_submissions
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

@router.get("/assignment-submission/{assignment_id}/{student_id}")
async def get_student_assignment_submission(assignment_id: int, student_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep
    
    try:
        query = """
            SELECT asb.submission_id, asb.assignment_id, asb.student_id, u.name AS student_name,
                   asb.file_path, asb.submission_text, asb.submitted_at,
                   asb.grade, asb.feedback
            FROM assignment_submissions asb
            JOIN users u ON asb.student_id = u.user_id
            WHERE asb.assignment_id = %s AND asb.student_id = %s
        """
        db.execute(query, (assignment_id, student_id))
        submission = db.fetchone()

        if not submission:
            raise HTTPException(status_code=404, detail="Assignment submission not found")

        return submission
    except HTTPException as he:
        raise he
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")
    finally:
        try:
            while db.fetchone():
                pass
        except:
            pass

@router.get("/assignment-submission/{submission_id}")
async def get_assignment_submission(submission_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    try:
        query = """
            SELECT asb.submission_id, asb.assignment_id, asb.student_id, u.name AS student_name,
                   asb.file_path, asb.submission_text, asb.submitted_at,
                   asb.grade, asb.feedback
            FROM assignment_submissions asb
            JOIN users u ON asb.student_id = u.user_id
            WHERE asb.submission_id = %s
        """
        db.execute(query, (submission_id,))
        submission = db.fetchone()

        if not submission:
            raise HTTPException(status_code=404, detail="Assignment submission not found")

        return submission
    except HTTPException as he:
        raise he
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")
    finally:
        try:
            while db.fetchone():
                pass
        except:
            pass