from fastapi import APIRouter, Depends, HTTPException, File, UploadFile, FastAPI
from pydantic import BaseModel
from fastapi.staticfiles import StaticFiles  # Add this import
from .db import get_db
from fastapi.responses import FileResponse
import os

# Create the FastAPI app instance
app = FastAPI()

# Serve static files
UPLOAD_DIR = "uploads"
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
    file_path: str  # The file path can be relative or an external URL
    submission_text: str

    def save(self, db_dep=Depends(get_db)):
        db, conn = db_dep

        # Check if file_path is a local file or an external URL
        if self.file_path.startswith("http") or self.file_path.startswith("https"):
            # It's an external URL (e.g., Google Form link)
            file_path = self.file_path  # No change, just store the URL as is
        else:
            # Store file path relative to the 'uploads' directory
            file_path = f"{UPLOAD_DIR}/{self.file_path}"

        query = """
            INSERT INTO assignment_submissions (student_id, assignment_id, file_path, submission_text)
            VALUES (%s, %s, %s, %s)
        """
        db.execute(query, (self.student_id, self.assignment_id, file_path, self.submission_text))
        conn.commit()


# ✅ Assign an Assignment to a Course
@router.post("/assignments/")
async def create_assignment(assignment: StudentAssignment, db_dep=Depends(get_db)):
    db, conn = db_dep

    # Check if course exists
    db.execute("SELECT course_id FROM courses WHERE course_id = %s", (assignment.course_id,))
    if not db.fetchone():
        raise HTTPException(status_code=400, detail="Course not found")
    
    # Insert assignment
    query = """
        INSERT INTO assignments (course_id, title, description, due_date)
        VALUES (%s, %s, %s, %s)
        RETURNING assignment_id
    """
    db.execute(query, (assignment.course_id, assignment.title, assignment.description, assignment.due_date))
    assignment_id = db.fetchone()["assignment_id"]
    conn.commit()

    return {"message": "Assignment created successfully", "assignment_id": assignment_id}

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
