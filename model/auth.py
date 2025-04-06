from fastapi import APIRouter, Depends, HTTPException, Query
from pydantic import BaseModel
from .db import get_db  # Import database dependency
from fastapi_mail import FastMail, MessageSchema, ConnectionConfig
from datetime import datetime, timedelta
import random
from jose import JWTError, jwt
from passlib.context import CryptContext
from config import SECRET_KEY, ALGORITHM, ACCESS_TOKEN_EXPIRE_MINUTES
from enum import Enum
from passlib.exc import UnknownHashError


# JWT and password hashing utilities
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Helper function to create access tokens
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
    MAIL_USERNAME="894d48001@smtp-brevo.com",  # Your Brevo SMTP login
    MAIL_PASSWORD="aMkyIFqrVKE462Rb",  # The generated SMTP key
    MAIL_FROM="wlage35@gmail.com",  # Your registered Brevo email
    MAIL_PORT=587,  # Use 587 for TLS
    MAIL_SERVER="smtp-relay.brevo.com",
    MAIL_STARTTLS=True,
    MAIL_SSL_TLS=False,
    USE_CREDENTIALS=True
)

fm = FastMail(conf)

# Pydantic Models
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
    role: UserRole  # Use UserRole enum here for type safety
    access_token: str
    token_type: str = "bearer"
    courses: list[CourseResponse]  # Ensures courses return correctly

@router.post("/login/", response_model=LoginResponse)
async def login_user(login_data: LoginRequest, db_dep=Depends(get_db)):
    cursor, _ = db_dep

    # Fetch user from database by email
    query = "SELECT user_id, name, email, password, role FROM users WHERE email = %s"
    cursor.execute(query, (login_data.email,))
    user = cursor.fetchone()

    if not user:
        raise HTTPException(status_code=401, detail="Invalid email or password")

    try:
        # Verify if password matches hash
        if not pwd_context.verify(login_data.password.strip(), user["password"].strip()):
            raise HTTPException(status_code=401, detail="Invalid email or password")
        
        # If the password is from an unrecognized hash format, rehash it
        if pwd_context.identify(user["password"].strip()) == 'unknown':
            # Rehash the password using the current scheme and update the database
            new_hashed_password = pwd_context.hash(login_data.password.strip())
            update_query = "UPDATE users SET password = %s WHERE email = %s"
            cursor.execute(update_query, (new_hashed_password, login_data.email))
            cursor.connection.commit()

    except UnknownHashError:
        # Handle password hash format issue (in case of a different hashing algorithm)
        raise HTTPException(status_code=401, detail="Password hash format is not recognized. Please contact support.")

    # Create a JWT token
    access_token = create_access_token(data={"sub": user["email"], "user_id": user["user_id"], "role": user["role"]})

    # Fetch courses for the user
    query_courses = "SELECT course_id, course_name, section, class_schedule FROM courses WHERE user_id = %s"
    cursor.execute(query_courses, (user["user_id"],))
    courses = cursor.fetchall()

    course_list = [CourseResponse(**course) for course in courses]

    # Generate 6-digit verification code
    verification_code = random.randint(100000, 999999)
    verification_codes[user["email"]] = {
        "code": verification_code,
        "expires_at": datetime.utcnow() + timedelta(minutes=5)
    }

    # Send verification code via email
    message = MessageSchema(
        subject="Your Verification Code",
        recipients=[user["email"]],
        body=f"Your verification code is: {verification_code}",
        subtype="plain"
    )

    try:
        await fm.send_message(message)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to send email: {str(e)}")

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