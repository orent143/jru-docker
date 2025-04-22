from fastapi import APIRouter, Depends, HTTPException, Query
from pydantic import BaseModel
from .db import get_db  
from fastapi_mail import FastMail, MessageSchema, ConnectionConfig
from datetime import datetime, timedelta
import random
from jose import JWTError, jwt
from passlib.context import CryptContext
from config import SECRET_KEY, ALGORITHM, ACCESS_TOKEN_EXPIRE_MINUTES
from enum import Enum
from passlib.exc import UnknownHashError


pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def create_access_token(data: dict):
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

verification_codes = {}

router = APIRouter()

# Configuration for email
conf = ConnectionConfig(
    MAIL_USERNAME="894d48001@smtp-brevo.com",  
    MAIL_PASSWORD="aMkyIFqrVKE462Rb",
    MAIL_FROM="wlage35@gmail.com", 
    MAIL_PORT=587,  
    MAIL_SERVER="smtp-relay.brevo.com",
    MAIL_STARTTLS=True,
    MAIL_SSL_TLS=False,
    USE_CREDENTIALS=True
)

fm = FastMail(conf)

class UserRole(str, Enum):
    student = "student"
    faculty = "faculty"
    admin = "admin"

class CourseResponse(BaseModel):
    course_id: int
    course_name: str
    section: str
    class_schedule: str

class LoginRequest(BaseModel):
    email: str
    password: str

class LoginResponse(BaseModel):
    user_id: int
    name: str
    email: str
    role: UserRole  
    access_token: str
    token_type: str = "bearer"
    courses: list[CourseResponse]  

@router.post("/login/", response_model=LoginResponse)
async def login_user(login_data: LoginRequest, db_dep=Depends(get_db)):
    cursor, _ = db_dep

    query = "SELECT user_id, name, email, password, role FROM users WHERE email = %s"
    cursor.execute(query, (login_data.email,))
    user = cursor.fetchone()

    if not user:
        raise HTTPException(status_code=401, detail="Invalid email or password")

    try:
        if not pwd_context.verify(login_data.password.strip(), user["password"].strip()):
            raise HTTPException(status_code=401, detail="Invalid email or password")
        
        if pwd_context.identify(user["password"].strip()) == 'unknown':
            new_hashed_password = pwd_context.hash(login_data.password.strip())
            update_query = "UPDATE users SET password = %s WHERE email = %s"
            cursor.execute(update_query, (new_hashed_password, login_data.email))
            cursor.connection.commit()

    except UnknownHashError:
        raise HTTPException(status_code=401, detail="Password hash format is not recognized. Please contact support.")

    access_token = create_access_token(data={"sub": user["email"], "user_id": user["user_id"], "role": user["role"]})

    query_courses = "SELECT course_id, course_name, section, class_schedule FROM courses WHERE user_id = %s"
    cursor.execute(query_courses, (user["user_id"],))
    courses = cursor.fetchall()

    course_list = [CourseResponse(**course) for course in courses]

    return {
        "user_id": user["user_id"],
        "name": user["name"],
        "email": user["email"],
        "role": user["role"],
        "access_token": access_token,
        "courses": course_list
    }

@router.post("/verify-code/")
async def verify_code(data: dict):
    email = data.get("email")
    code = data.get("code")

    if email not in verification_codes:
        raise HTTPException(status_code=400, detail="No verification code found for this email.")

    verification_data = verification_codes[email]

    if verification_data["expires_at"] < datetime.utcnow():
        del verification_codes[email]
        raise HTTPException(status_code=400, detail="Code expired.")

    if verification_data["code"] != code:
        raise HTTPException(status_code=400, detail="Incorrect code.")

    del verification_codes[email]

    return {"message": "Verification successful"}
