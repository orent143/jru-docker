# model/instructors.py
from fastapi import Depends, HTTPException, APIRouter
from .db import get_db

router = APIRouter()

@router.get("/instructors/")
async def get_instructors(db=Depends(get_db)):
    db.execute("SELECT instructor_id, user_id, first_name, last_name, department FROM instructors")
    instructors = [{"instructor_id": i[0], "user_id": i[1], "first_name": i[2], "last_name": i[3], "department": i[4]} for i in db.fetchall()]
    return instructors

@router.get("/instructors/{instructor_id}")
async def get_instructor(instructor_id: int, db=Depends(get_db)):
    db.execute("SELECT instructor_id, user_id, first_name, last_name, department FROM instructors WHERE instructor_id = %s", (instructor_id,))
    instructor = db.fetchone()
    if instructor:
        return {"instructor_id": instructor[0], "user_id": instructor[1], "first_name": instructor[2], "last_name": instructor[3], "department": instructor[4]}
    raise HTTPException(status_code=404, detail="Instructor not found")

@router.post("/instructors/")
async def create_instructor(user_id: int, first_name: str, last_name: str, department: str, db=Depends(get_db)):
    db.execute("INSERT INTO instructors (user_id, first_name, last_name, department) VALUES (%s, %s, %s, %s)", (user_id, first_name, last_name, department))
    db.connection.commit()
    return {"message": "Instructor created successfully"}

@router.delete("/instructors/{instructor_id}")
async def delete_instructor(instructor_id: int, db=Depends(get_db)):
    db.execute("DELETE FROM instructors WHERE instructor_id = %s", (instructor_id,))
    db.connection.commit()
    return {"message": "Instructor deleted successfully"}
