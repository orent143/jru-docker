from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime
from .db import get_db

router = APIRouter()

class CommentBase(BaseModel):
    content: str
    entity_type: str  
    entity_id: int    
    
class CommentCreate(CommentBase):
    user_id: int
    
class CommentResponse(CommentBase):
    comment_id: int
    user_id: int
    user_name: str
    created_at: datetime
    
    class Config:
        orm_mode = True

@router.post("/comments/", response_model=CommentResponse)
async def create_comment(comment: CommentCreate, db=Depends(get_db)):
    cursor, conn = db
    
    cursor.execute("SELECT name FROM users WHERE user_id = %s", (comment.user_id,))
    user = cursor.fetchone()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    if comment.entity_type == "assignment":
        cursor.execute("SELECT assignment_id FROM assignments WHERE assignment_id = %s", (comment.entity_id,))
    elif comment.entity_type == "quiz":
        cursor.execute("SELECT quiz_id FROM quizzes WHERE quiz_id = %s", (comment.entity_id,))
    elif comment.entity_type == "material":
        cursor.execute("SELECT content_id FROM course_content WHERE content_id = %s", (comment.entity_id,))
    elif comment.entity_type == "exam":
        cursor.execute("SELECT exam_id FROM exams WHERE exam_id = %s", (comment.entity_id,))
    else:
        raise HTTPException(status_code=400, detail="Invalid entity type")
    
    entity = cursor.fetchone()
    if not entity:
        raise HTTPException(status_code=404, detail="Entity not found")
    
    query = """
        INSERT INTO comments (user_id, entity_type, entity_id, content, created_at)
        VALUES (%s, %s, %s, %s, NOW())
    """
    cursor.execute(query, (comment.user_id, comment.entity_type, comment.entity_id, comment.content))
    conn.commit()
    
    comment_id = cursor.lastrowid
    cursor.execute("""
        SELECT c.comment_id, c.user_id, u.name as user_name, c.entity_type, 
               c.entity_id, c.content, c.created_at
        FROM comments c
        JOIN users u ON c.user_id = u.user_id
        WHERE c.comment_id = %s
    """, (comment_id,))
    
    result = cursor.fetchone()
    return result

@router.get("/comments/{entity_type}/{entity_id}", response_model=List[CommentResponse])
async def get_comments(entity_type: str, entity_id: int, db=Depends(get_db)):
    cursor, _ = db
    
    if entity_type not in ["assignment", "quiz", "material", "exam"]:
        raise HTTPException(status_code=400, detail="Invalid entity type")
    
    query = """
        SELECT c.comment_id, c.user_id, u.name as user_name, c.entity_type, 
               c.entity_id, c.content, c.created_at
        FROM comments c
        JOIN users u ON c.user_id = u.user_id
        WHERE c.entity_type = %s AND c.entity_id = %s
        ORDER BY c.created_at DESC
    """
    cursor.execute(query, (entity_type, entity_id))
    comments = cursor.fetchall()
    
    return comments

@router.delete("/comments/{comment_id}")
async def delete_comment(comment_id: int, user_id: int, db=Depends(get_db)):
    cursor, conn = db
    
    cursor.execute(
        "SELECT user_id FROM comments WHERE comment_id = %s", (comment_id,)
    )
    comment = cursor.fetchone()
    
    if not comment:
        raise HTTPException(status_code=404, detail="Comment not found")
    
    if comment["user_id"] != user_id:
        raise HTTPException(status_code=403, detail="Not authorized to delete this comment")
    
    cursor.execute("DELETE FROM comments WHERE comment_id = %s", (comment_id,))
    conn.commit()
    
    return {"message": "Comment deleted successfully"} 