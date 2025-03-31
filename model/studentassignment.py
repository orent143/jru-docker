from fastapi import APIRouter, Depends, HTTPException, File, UploadFile, FastAPI, Form
from pydantic import BaseModel
from fastapi.staticfiles import StaticFiles
from fastapi.responses import JSONResponse
import os
import uuid  # To generate unique filenames
from .db import get_db

# Create the FastAPI app instance
app = FastAPI()

# Serve static files
UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)  # Ensure upload directory exists
app.mount("/uploads", StaticFiles(directory=UPLOAD_DIR), name="uploads")

# Router for handling routes related to assignments
router = APIRouter()

# Define schemas (models)
class StudentAssignment(BaseModel):
    student_id: int
    course_id: int
    title: str
    description: str
    due_date: str

class AssignmentSubmission(BaseModel):
    student_id: int
    assignment_id: int
    file_path: str = None  # Store file path or external link
    external_link: str = None  # Add external link field
    submission_text: str


@router.post("/submit-assignment/")
async def submit_assignment(
    student_id: int,
    assignment_id: int,
    file: UploadFile = File(None),            # Optional file upload
    external_link: str = Form(None),          # Optional external link
    submission_text: str = Form(...),         # Required submission text
    db_dep=Depends(get_db)
):
    """Handle assignment submission."""
    db, conn = db_dep

    # ✅ Check if the assignment exists
    db.execute("SELECT * FROM assignments WHERE assignment_id = %s", (assignment_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Assignment not found")

    # ✅ Handle file upload or external link
    file_path = None

    # 1️⃣ If file is provided, save it to the upload directory with a unique filename
    if file and file.filename:
        unique_filename = f"{uuid.uuid4()}_{file.filename}"
        file_path = os.path.join(UPLOAD_DIR, unique_filename)
        try:
            with open(file_path, "wb") as f:
                f.write(await file.read())
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Failed to save file: {str(e)}")

    # 2️⃣ If external link is provided
    elif external_link:
        file_path = external_link

    if not file_path:
        raise HTTPException(status_code=400, detail="Either a file or an external link must be provided")

    # ✅ Save the submission to the database
    query = """
        INSERT INTO assignment_submissions (student_id, assignment_id, file_path, submission_text)
        VALUES (%s, %s, %s, %s)
    """
    db.execute(query, (student_id, assignment_id, file_path or external_link, submission_text))
    conn.commit()

    return JSONResponse(
        content={"message": "Submission successful", "file_path": file_path}, 
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

    # Check if student is enrolled in the course
    db.execute("SELECT * FROM student_courses WHERE student_id = %s AND course_id = %s", (student_id, course_id))
    if not db.fetchone():
        raise HTTPException(status_code=403, detail="Student is not enrolled in this course")

    # Get the course name
    db.execute("SELECT course_name FROM courses WHERE course_id = %s", (course_id,))
    course = db.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    # Get assignments for the course
    query = """
        SELECT assignment_id, title, description, due_date, file_path, external_link
        FROM assignments
        WHERE course_id = %s ORDER BY due_date ASC
    """
    db.execute(query, (course_id,))
    assignments = db.fetchall()

    # Separate the file_path and external_link in the response
    result = []
    for assignment in assignments:
        result.append({
            "assignment_id": assignment["assignment_id"],
            "title": assignment["title"],
            "description": assignment["description"],
            "due_date": assignment["due_date"],
            "file_path": assignment["file_path"] if assignment["file_path"] else None,
            "external_link": assignment["external_link"] if assignment["external_link"] else None
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
        SELECT student_id, file_path, submission_text, submitted_at
        FROM assignment_submissions
        WHERE assignment_id = %s ORDER BY submitted_at DESC
    """
    db.execute(query, (assignment_id,))
    submissions = db.fetchall()

    return {
        "assignment_id": assignment_id,
        "submissions": submissions
    }

@router.get("/assignment_submissions/download/{file_name}")
async def download_submission_file(file_name: str):
    # Sanitize file name to avoid directory traversal attacks
    file_name = os.path.basename(file_name)  # Prevent directory traversal
    file_path = os.path.join(UPLOAD_DIR, file_name)

    # Check if the file exists in the uploads directory
    if os.path.exists(file_path):
        return FileResponse(file_path, headers={"Content-Disposition": f"attachment; filename={file_name}"})
    
    raise HTTPException(status_code=404, detail="File not found")

@router.get("/assignments/download/{file_name}")
async def download_file(file_name: str):
    # Sanitize the file name to prevent directory traversal attacks
    file_name = os.path.basename(file_name)  # Only keep the base file name
    file_path = os.path.join(UPLOAD_DIR, file_name)

    # Check if the file exists
    if os.path.exists(file_path):
        return FileResponse(file_path, headers={"Content-Disposition": f"attachment; filename={file_name}"})
    
    raise HTTPException(status_code=404, detail="File not found")
