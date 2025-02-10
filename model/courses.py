# model/courses.py
from fastapi import Depends, HTTPException, APIRouter
from pydantic import BaseModel
from .db import get_db

router = APIRouter()

# ✅ Schema
class CourseCreate(BaseModel):
    name: str
    description: str

class CourseUpdate(BaseModel):
    name: str
    description: str

# ✅ CREATE (POST)
@router.post("/courses/")
async def create_course(course: CourseCreate, db=Depends(get_db)):
    query = "INSERT INTO courses (name, description) VALUES (%s, %s)"
    db.execute(query, (course.name, course.description))
    db.connection.commit()
    return {"message": "Course created successfully"}

# ✅ READ ALL (GET)
@router.get("/courses/")
async def read_courses(db=Depends(get_db)):
    query = "SELECT id, name, description FROM courses"
    db.execute(query)
    return db.fetchall()

# ✅ READ ONE (GET by ID)
@router.get("/courses/{course_id}")
async def read_course(course_id: int, db=Depends(get_db)):
    query = "SELECT id, name, description FROM courses WHERE id = %s"
    db.execute(query, (course_id,))
    course = db.fetchone()
    if course:
        return course
    raise HTTPException(status_code=404, detail="Course not found")

# ✅ UPDATE (PUT)
@router.put("/courses/{course_id}")
async def update_course(course_id: int, course: CourseUpdate, db=Depends(get_db)):
    query = "UPDATE courses SET name = %s, description = %s WHERE id = %s"
    db.execute(query, (course.name, course.description, course_id))
    db.connection.commit()
    if db.rowcount == 0:
        raise HTTPException(status_code=404, detail="Course not found")
    return {"message": "Course updated successfully"}

# ✅ DELETE (DELETE)
@router.delete("/courses/{course_id}")
async def delete_course(course_id: int, db=Depends(get_db)):
    query = "DELETE FROM courses WHERE id = %s"
    db.execute(query, (course_id,))
    db.connection.commit()
    if db.rowcount == 0:
        raise HTTPException(status_code=404, detail="Course not found")
    return {"message": "Course deleted successfully"}
