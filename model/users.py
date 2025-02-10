from fastapi import Depends, HTTPException, APIRouter
from pydantic import BaseModel
from typing import List, Optional
from .db import get_db

router = APIRouter()

# Pydantic Models
class UserCreate(BaseModel):
    name: str
    email: str
    password: str  # Stored as plain text for now (not recommended)
    role: str  # Should be 'student', 'faculty', or 'admin'

class UserUpdate(BaseModel):
    name: Optional[str] = None
    email: Optional[str] = None
    password: Optional[str] = None
    role: Optional[str] = None

class UserResponse(BaseModel):
    user_id: int
    name: str
    email: str
    role: str
    created_at: str

# 🚀 Get all users (READ)
@router.get("/users/", response_model=List[UserResponse])
async def get_users(db=Depends(get_db)):
    query = "SELECT user_id, name, email, role, created_at FROM users"
    db.execute(query)
    users = db.fetchall()
    return [
        {"user_id": user[0], "name": user[1], "email": user[2], "role": user[3], "created_at": str(user[4])}
        for user in users
    ]

# 🚀 Get a single user by ID (READ)
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

# 🚀 Create a new user (CREATE)
@router.post("/users/", response_model=UserResponse)
async def create_user(user: UserCreate, db=Depends(get_db)):
    query = "INSERT INTO users (name, email, password, role) VALUES (%s, %s, %s, %s)"
    values = (user.name, user.email, user.password, user.role)

    try:
        db.execute(query, values)
        db.connection.commit()
        user_id = db.lastrowid  # Get the inserted user's ID
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error creating user: {str(e)}")

    return {
        "user_id": user_id,
        "name": user.name,
        "email": user.email,
        "role": user.role,
        "created_at": "Just now"
    }

# 🚀 Update a user (UPDATE)
@router.put("/users/{user_id}", response_model=UserResponse)
async def update_user(user_id: int, user: UserUpdate, db=Depends(get_db)):
    query = "SELECT user_id FROM users WHERE user_id = %s"
    db.execute(query, (user_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="User not found")

    update_fields = []
    values = []

    if user.name:
        update_fields.append("name = %s")
        values.append(user.name)
    if user.email:
        update_fields.append("email = %s")
        values.append(user.email)
    if user.password:
        update_fields.append("password = %s")
        values.append(user.password)
    if user.role:
        update_fields.append("role = %s")
        values.append(user.role)

    if not update_fields:
        raise HTTPException(status_code=400, detail="No fields to update")

    query = f"UPDATE users SET {', '.join(update_fields)} WHERE user_id = %s"
    values.append(user_id)

    try:
        db.execute(query, tuple(values))
        db.connection.commit()
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error updating user: {str(e)}")

    return await get_user(user_id, db)

# 🚀 Delete a user (DELETE)
@router.delete("/users/{user_id}")
async def delete_user(user_id: int, db=Depends(get_db)):
    query = "SELECT user_id FROM users WHERE user_id = %s"
    db.execute(query, (user_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="User not found")

    query = "DELETE FROM users WHERE user_id = %s"
    db.execute(query, (user_id,))
    db.connection.commit()

    return {"message": "User deleted successfully"}
