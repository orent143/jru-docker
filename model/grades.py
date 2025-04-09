from fastapi import Depends, HTTPException, APIRouter 
from pydantic import BaseModel
from .db import get_db
from enum import Enum

router = APIRouter()

# Enum for Semester
class Semester(str, Enum):
    first = '1st'
    second = '2nd'

# Updated GradeCreate to include all terms and the overall grade
class GradeCreate(BaseModel):
    student_id: int
    course_id: int
    prelim_grade: float = None  # Optional, for Prelim term
    midterm_grade: float = None  # Optional, for Midterm term
    finals_grade: float = None  # Optional, for Finals term
    school_year: str
    semester: str  # '1st' or '2nd'

# GradeUpdate now supports all terms and overall grade
class GradeUpdate(BaseModel):
    prelim_grade: float = None  # Optional for Prelim term
    midterm_grade: float = None  # Optional for Midterm term
    finals_grade: float = None  # Optional for Finals term
    school_year: str
    semester: str

# Assign grade (create a grade record)
@router.post("/grades/")
async def assign_grade(grade: GradeCreate, db=Depends(get_db)):
    cursor, connection = db
    
    check_grade_query = """
        SELECT grade_id FROM grades
        WHERE student_id = %s AND course_id = %s AND school_year = %s AND semester = %s
    """
    cursor.execute(check_grade_query, (
        grade.student_id, grade.course_id, grade.school_year, grade.semester))
    if cursor.fetchone():
        raise HTTPException(status_code=400, detail="Grade already exists for this student")

    overall_grade = calculate_overall_grade(grade.prelim_grade, grade.midterm_grade, grade.finals_grade)

    insert_query = """
        INSERT INTO grades (student_id, course_id, prelim_grade, midterm_grade, finals_grade, overall_grade, school_year, semester)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
    """
    cursor.execute(insert_query, (
        grade.student_id, grade.course_id, grade.prelim_grade, grade.midterm_grade, grade.finals_grade,
        overall_grade, grade.school_year, grade.semester))
    connection.commit()

    return {"message": "Grade assigned successfully"}

def calculate_overall_grade(prelim: float, midterm: float, finals: float) -> float:
    # Example of a simple averaging of grades; modify based on your grading policy
    total = 0
    count = 0
    if prelim is not None:
        total += prelim
        count += 1
    if midterm is not None:
        total += midterm
        count += 1
    if finals is not None:
        total += finals
        count += 1
    return total / count if count > 0 else 0

# Get grades by course ID
@router.get("/courses/{course_id}/grades")
async def get_course_grades(course_id: int, db=Depends(get_db)):
    cursor, connection = db
    query = """
        SELECT g.grade_id, g.student_id, u.name as student_name, 
               g.prelim_grade, g.midterm_grade, g.finals_grade, g.overall_grade, g.school_year, g.semester
        FROM grades g 
        JOIN users u ON g.student_id = u.user_id 
        WHERE g.course_id = %s
        ORDER BY u.name, g.school_year, g.semester
    """
    cursor.execute(query, (course_id,))
    grades = [
        {
            "grade_id": row["grade_id"],
            "student_id": row["student_id"],
            "student_name": row["student_name"],
            "prelim_grade": row["prelim_grade"],
            "midterm_grade": row["midterm_grade"],
            "finals_grade": row["finals_grade"],
            "overall_grade": row["overall_grade"],
            "school_year": row["school_year"],
            "semester": row["semester"]
        }
        for row in cursor.fetchall()
    ]
    return grades

# Update grade for a specific student and course
@router.put("/grades/{student_id}/{course_id}")
async def update_grade(student_id: int, course_id: int, grade_update: GradeUpdate, db=Depends(get_db)):
    cursor, connection = db

    check_query = """
        SELECT grade_id FROM grades 
        WHERE student_id = %s AND course_id = %s AND school_year = %s AND semester = %s
    """
    cursor.execute(check_query, (
        student_id, course_id, grade_update.school_year, grade_update.semester))
    if not cursor.fetchone():
        raise HTTPException(status_code=404, detail="Grade not found")

    overall_grade = calculate_overall_grade(grade_update.prelim_grade, grade_update.midterm_grade, grade_update.finals_grade)

    update_query = """
        UPDATE grades 
        SET prelim_grade = %s, midterm_grade = %s, finals_grade = %s, overall_grade = %s
        WHERE student_id = %s AND course_id = %s AND school_year = %s AND semester = %s
    """
    cursor.execute(update_query, (
        grade_update.prelim_grade, grade_update.midterm_grade, grade_update.finals_grade, overall_grade,
        student_id, course_id, grade_update.school_year, grade_update.semester))
    connection.commit()

    return {"message": "Grade updated successfully"}

# Delete grade
@router.delete("/grades/{grade_id}")
async def delete_grade(grade_id: int, db=Depends(get_db)):
    connection, cursor = db

    check_query = "SELECT grade_id FROM grades WHERE grade_id = %s"
    cursor.execute(check_query, (grade_id,))
    if not cursor.fetchone():
        raise HTTPException(status_code=404, detail="Grade not found")

    delete_query = "DELETE FROM grades WHERE grade_id = %s"
    cursor.execute(delete_query, (grade_id,))
    connection.commit()

    return {"message": "Grade deleted successfully"}
