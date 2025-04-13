from fastapi import FastAPI, Depends, HTTPException, APIRouter, Form, File, UploadFile
from pydantic import BaseModel
import os
from .db import get_db
from fastapi.responses import JSONResponse, FileResponse
from fastapi.staticfiles import StaticFiles

app = FastAPI()

UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)

app.mount("/uploads", StaticFiles(directory=UPLOAD_DIR), name="uploads")

router = APIRouter()

class QuizCreate(BaseModel):
    course_id: int
    title: str
    description: str
    quiz_date: str
    duration_minutes: int
    external_link: str = None  
    file_path: str = None

class QuizUpdate(BaseModel):
    title: str
    description: str
    quiz_date: str
    duration_minutes: int
    external_link: str = None  
    file_path: str = None

@router.post("/quizzes")
async def create_quiz(
    course_id: int = Form(...),
    title: str = Form(...),
    description: str = Form(...),
    quiz_date: str = Form(...),
    duration_minutes: int = Form(...),
    file: UploadFile = File(None),
    external_link: str = Form(None), 
    db=Depends(get_db)
):
    cursor, connection = db

    cursor.execute("SELECT user_id FROM courses WHERE course_id = %s", (course_id,))
    course = cursor.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    user_id = course["user_id"]

    file_path = None
    if file:
        os.makedirs(UPLOAD_DIR, exist_ok=True)
        file_path = os.path.join(UPLOAD_DIR, file.filename)
        with open(file_path, "wb") as buffer:
            buffer.write(file.file.read())

        file_path = f"/uploads/{file.filename}"
    elif external_link:
        file_path = external_link  # Store external link in the file_path field

    query = """
    INSERT INTO quizzes (course_id, title, description, quiz_date, duration_minutes, file_path, user_id)
    VALUES (%s, %s, %s, %s, %s, %s, %s)
    """
    cursor.execute(query, (course_id, title, description, quiz_date, duration_minutes, file_path, user_id))
    connection.commit()

    quiz_id = cursor.lastrowid

    return {
        "quiz_id": quiz_id,
        "title": title,
        "description": description,
        "quiz_date": quiz_date,
        "duration_minutes": duration_minutes,
        "file_path": file_path,
        "user_id": user_id
    }

@router.get("/quizzes/quizzes/{course_id}")
async def get_quizzes(course_id: int, db=Depends(get_db)):
    cursor, _ = db

    cursor.execute("SELECT course_name FROM courses WHERE course_id = %s", (course_id,))
    course = cursor.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    course_name = course["course_name"]

    cursor.execute("""
        SELECT q.quiz_id, q.title, q.description, q.quiz_date, q.duration_minutes, q.file_path, u.name AS instructor_name
        FROM quizzes q
        JOIN users u ON q.user_id = u.user_id
        WHERE q.course_id = %s
    """, (course_id,))

    quizzes = cursor.fetchall()

    return {
        "course_name": course_name,
        "quizzes": [
            {
                "quiz_id": q["quiz_id"],
                "title": q["title"],
                "description": q["description"],
                "quiz_date": q["quiz_date"],
                "duration_minutes": q["duration_minutes"],
                "file_path": q["file_path"],
                "instructor_name": q["instructor_name"]
            }
            for q in quizzes
        ]
    }


@router.get("/quizzes/item/{quiz_id}")
async def get_quiz(quiz_id: int, db=Depends(get_db)):
    cursor, _ = db
    query = "SELECT quiz_id, title, description, quiz_date, duration_minutes, file_path FROM quizzes WHERE quiz_id = %s"
    cursor.execute(query, (quiz_id,))
    quiz = cursor.fetchone()

    if not quiz:
        raise HTTPException(status_code=404, detail="Quiz not found")

    return {
        "quiz_id": quiz["quiz_id"],
        "title": quiz["title"],
        "description": quiz["description"],
        "quiz_date": quiz["quiz_date"],
        "duration_minutes": quiz["duration_minutes"],
        "file_path": quiz["file_path"]
    }

@router.get("/quizzes/download/{file_name}")
async def download_file(file_name: str):
    file_name = os.path.basename(file_name)  
    file_path = os.path.join(UPLOAD_DIR, file_name)

    if os.path.exists(file_path):
        return FileResponse(file_path, headers={"Content-Disposition": f"attachment; filename={file_name}"})
    
    raise HTTPException(status_code=404, detail="File not found")

@router.put("/quizzes/{quiz_id}")
async def update_quiz(
    quiz_id: int,
    title: str = Form(...),
    description: str = Form(...),
    quiz_date: str = Form(...),
    duration_minutes: int = Form(...),
    file: UploadFile = File(None),
    external_link: str = Form(None),
    db=Depends(get_db)
):
    cursor, connection = db
    
    # Check if quiz exists
    cursor.execute("SELECT * FROM quizzes WHERE quiz_id = %s", (quiz_id,))
    existing_quiz = cursor.fetchone()
    if not existing_quiz:
        raise HTTPException(status_code=404, detail="Quiz not found")
    
    # Handle file upload or external link
    file_path = existing_quiz["file_path"]  # Default to existing file path
    
    if file and file.filename:
        # Upload new file
        os.makedirs(UPLOAD_DIR, exist_ok=True)
        file_path = os.path.join(UPLOAD_DIR, file.filename)
        with open(file_path, "wb") as buffer:
            buffer.write(file.file.read())
        file_path = f"/uploads/{file.filename}"
    elif external_link:
        # Use external link
        file_path = external_link  # Store external link in file_path
    
    # Update quiz in database
    query = """
    UPDATE quizzes 
    SET title = %s, description = %s, quiz_date = %s, duration_minutes = %s, file_path = %s
    WHERE quiz_id = %s
    """
    cursor.execute(query, (title, description, quiz_date, duration_minutes, file_path, quiz_id))
    connection.commit()
    
    return {
        "message": "Quiz updated successfully",
        "quiz_id": quiz_id,
        "title": title,
        "description": description,
        "quiz_date": quiz_date,
        "duration_minutes": duration_minutes,
        "file_path": file_path
    }

@router.delete("/quizzes/{quiz_id}")
async def delete_quiz(quiz_id: int, db=Depends(get_db)):
    cursor, connection = db
    query = "DELETE FROM quizzes WHERE quiz_id = %s"
    cursor.execute(query, (quiz_id,))
    connection.commit()
    if cursor.rowcount == 0:
        raise HTTPException(status_code=404, detail="Quiz not found")
    return {"message": "Quiz deleted successfully"}

app.include_router(router)


