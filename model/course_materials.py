# model/course_materials.py
from fastapi import Depends, HTTPException, APIRouter
from pydantic import BaseModel
from .db import get_db

router = APIRouter()

class CourseMaterialCreate(BaseModel):
    course_id: int
    title: str
    content: str

@router.post("/course_materials/")
async def create_material(material: CourseMaterialCreate, db=Depends(get_db)):
    query = "INSERT INTO course_materials (course_id, title, content) VALUES (%s, %s, %s)"
    db.execute(query, (material.course_id, material.title, material.content))
    db.connection.commit()
    return {"message": "Material added successfully"}

@router.get("/course_materials/{course_id}")
async def get_materials(course_id: int, db=Depends(get_db)):
    query = "SELECT id, title, content FROM course_materials WHERE course_id = %s"
    db.execute(query, (course_id,))
    return db.fetchall()
