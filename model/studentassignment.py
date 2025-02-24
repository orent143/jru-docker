from fastapi import Depends, HTTPException, APIRouter
from pydantic import BaseModel
from .db import get_db

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
    file_path: str
    submission_text: str

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

# ✅ Get Assignments for a Course
@router.get("/assignments/{course_id}")
async def get_course_assignments(course_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT course_id FROM courses WHERE course_id = %s", (course_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Course not found")

    query = """
        SELECT assignment_id, title, description, due_date FROM assignments
        WHERE course_id = %s ORDER BY due_date ASC
    """
    db.execute(query, (course_id,))
    assignments = db.fetchall()

    return {"course_id": course_id, "assignments": assignments}

# ✅ Get Assignments for a Specific Student
@router.get("/student_assignments/{student_id}/{course_id}")
async def get_student_assignments(student_id: int, course_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT * FROM student_courses WHERE student_id = %s AND course_id = %s", (student_id, course_id))
    if not db.fetchone():
        raise HTTPException(status_code=403, detail="Student is not enrolled in this course")

    query = """
        SELECT assignment_id, title, description, due_date FROM assignments
        WHERE course_id = %s ORDER BY due_date ASC
    """
    db.execute(query, (course_id,))
    assignments = db.fetchall()

    return {"student_id": student_id, "course_id": course_id, "assignments": assignments}

# ✅ Submit an Assignment
@router.post("/assignment_submissions/")
async def submit_assignment(submission: AssignmentSubmission, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT * FROM assignments WHERE assignment_id = %s", (submission.assignment_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Assignment not found")

    db.execute("SELECT * FROM student_courses WHERE student_id = %s", (submission.student_id,))
    if not db.fetchone():
        raise HTTPException(status_code=403, detail="Student is not enrolled in this course")

    query = """
        INSERT INTO assignment_submissions (assignment_id, student_id, file_path, submission_text)
        VALUES (%s, %s, %s, %s)
    """
    db.execute(query, (submission.assignment_id, submission.student_id, submission.file_path, submission.submission_text))
    conn.commit()

    return {"message": "Assignment submitted successfully"}

# ✅ Get Submitted Assignments
@router.get("/assignment_submissions/{assignment_id}")
async def get_submitted_assignments(assignment_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT * FROM assignments WHERE assignment_id = %s", (assignment_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Assignment not found")

    query = """
        SELECT student_id, file_path, submission_text, submitted_at FROM assignment_submissions
        WHERE assignment_id = %s ORDER BY submitted_at DESC
    """
    db.execute(query, (assignment_id,))
    submissions = db.fetchall()

    return {"assignment_id": assignment_id, "submissions": submissions}
