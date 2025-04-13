from fastapi import Depends, HTTPException, APIRouter
from pydantic import BaseModel, EmailStr, model_validator
from typing import List, Optional
from .db import get_db
from sqlalchemy.orm import Session
from .utils import get_current_user, pwd_context  
from enum import Enum

router = APIRouter()

class UserRole(str, Enum):
    student = "student"
    faculty = "faculty"
    admin = "admin"


class UserCreate(BaseModel):
    name: str
    email: EmailStr
    password: str 
    role: UserRole
    degree: Optional[str] = None 

    @model_validator(mode="after")
    def check_degree_for_student(self):
        if self.role == UserRole.student and not self.degree:
            raise ValueError("Degree is required when role is 'student'")
        return self

class UserUpdate(BaseModel):
    name: Optional[str] = None
    email: Optional[str] = None
    password: Optional[str] = None
    role: Optional[UserRole] = None
    degree: Optional[str] = None 

class UserResponse(BaseModel):
    user_id: int
    name: str
    email: str
    role: str
    created_at: str
    degree: Optional[str] = None 
class PasswordUpdate(BaseModel):
    user_id: int
    new_password: str

@router.get("/protected")
async def protected_route(current_user: dict = Depends(get_current_user)):
    """
    This is a protected route. Only accessible with a valid JWT token.
    """
    return {"message": f"Hello, {current_user['sub']}"}

@router.get("/users/", response_model=List[UserResponse])
async def get_users(db_dep=Depends(get_db)):
    db, conn = db_dep  
    query = """
        SELECT 
            u.user_id, 
            u.name, 
            u.email, 
            u.role, 
            u.created_at, 
            CASE 
                WHEN u.role = 'student' THEN s.degree 
                ELSE NULL 
            END AS degree
        FROM users u
        LEFT JOIN students s ON u.user_id = s.user_id
    """
    db.execute(query)
    users = db.fetchall()

    return [
        {
            "user_id": user["user_id"],
            "name": user["name"],
            "email": user["email"],
            "role": user["role"],
            "created_at": str(user["created_at"]),
            "degree": user["degree"] 
        }
        for user in users
    ]

@router.get("/users/{user_id}", response_model=UserResponse)
async def get_user(user_id: int, db=Depends(get_db)):
    query = "SELECT user_id, name, email, role, created_at FROM users WHERE user_id = %s"
    db.execute(query, (user_id,))
    user = db.fetchone()
    
    if user:
        return {
            "user_id": user[0],
            "name": user[1],
            "email": user[2],
            "role": user[3],
            "created_at": str(user[4])
        }
    
    raise HTTPException(status_code=404, detail="User not found")

@router.post("/users/", response_model=UserResponse)
async def create_user(user: UserCreate, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT user_id FROM users WHERE email = %s", (user.email,))
    if db.fetchone():
        raise HTTPException(status_code=400, detail="Email is already registered.")
    
    hashed_password = pwd_context.hash(user.password)

    query = "INSERT INTO users (name, email, password, role) VALUES (%s, %s, %s, %s)"
    values = (user.name, user.email, hashed_password, user.role.value)

    try:
        db.execute(query, values)
        conn.commit()
        user_id = db.lastrowid  

        if user.role == UserRole.student:
            first_name, last_name = user.name.split()[0], user.name.split()[-1] if " " in user.name else ""
            db.execute("INSERT INTO students (user_id, student_number, first_name, last_name, degree) VALUES (%s, %s, %s, %s, %s)", 
                       (user_id, f"SN{user_id:06d}", first_name, last_name, user.degree))
            conn.commit()
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Error creating user: {str(e)}")

    return {
        "user_id": user_id,
        "name": user.name,
        "email": user.email,
        "role": user.role.value,
        "created_at": "Just now"
    }


@router.put("/users/{user_id}")
async def update_user(user_id: int, user_update: UserUpdate, db_dep=Depends(get_db)):
    db, conn = db_dep  

    db.execute("SELECT user_id, role FROM users WHERE user_id = %s", (user_id,))
    existing_user = db.fetchone()
    if not existing_user:
        raise HTTPException(status_code=404, detail="User not found")
    
    current_role = existing_user["role"]

    update_data = {key: value for key, value in user_update.dict().items() if value is not None}
    if not update_data:
        raise HTTPException(status_code=400, detail="No fields provided for update")

    user_fields = {k: v for k, v in update_data.items() if k in ["name", "email", "password", "role"]}
    if "password" in user_fields:
        user_fields["password"] = pwd_context.hash(user_fields["password"])

    if user_fields:
        set_clause = ", ".join(f"{key} = %s" for key in user_fields.keys())
        values = list(user_fields.values()) + [user_id]
        db.execute(f"UPDATE users SET {set_clause} WHERE user_id = %s", values)

    role_is_student = update_data.get("role", current_role) == UserRole.student

    if role_is_student:
        name_to_use = update_data.get("name")
        if name_to_use:
            first_name, last_name = name_to_use.split()[0], name_to_use.split()[-1] if " " in name_to_use else ""
            db.execute("""
                INSERT INTO students (user_id, student_number, first_name, last_name, degree)
                VALUES (%s, %s, %s, %s, %s)
                ON DUPLICATE KEY UPDATE first_name = VALUES(first_name), last_name = VALUES(last_name)
            """, (user_id, f"SN{user_id:06d}", first_name, last_name, update_data.get("degree", "")))
        elif "degree" in update_data:
            db.execute("UPDATE students SET degree = %s WHERE user_id = %s", (update_data["degree"], user_id))

    conn.commit()
    return {"message": "User updated successfully"}

@router.delete("/users/{user_id}")
async def delete_user(user_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    db.execute("SELECT user_id FROM users WHERE user_id = %s", (user_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="User not found")

    try:
        db.execute("DELETE FROM students WHERE user_id = %s", (user_id,))
        db.execute("DELETE FROM users WHERE user_id = %s", (user_id,))
        conn.commit()
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

    return {"message": "User deleted successfully"}

@router.post("/update-password/")
async def update_password(password_update: PasswordUpdate, db_dep=Depends(get_db)):
    db, conn = db_dep
    
    db.execute("SELECT user_id FROM users WHERE user_id = %s", (password_update.user_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="User not found")
    
    hashed_password = pwd_context.hash(password_update.new_password)
    
    try:
        query = "UPDATE users SET password = %s WHERE user_id = %s"
        db.execute(query, (hashed_password, password_update.user_id))
        conn.commit()
        return {"message": "Password updated successfully"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Error updating password: {str(e)}")
