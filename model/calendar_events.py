from fastapi import Depends, HTTPException, APIRouter
from pydantic import BaseModel
from typing import Optional
from .db import get_db

router = APIRouter()

class EventCreate(BaseModel):
    title: str
    date: str
    time: Optional[str] = None
    description: Optional[str] = None
    type: str
    user_id: int
    course_id: Optional[int] = None

class EventUpdate(BaseModel):
    title: Optional[str] = None
    date: Optional[str] = None
    time: Optional[str] = None
    description: Optional[str] = None
    type: Optional[str] = None
    course_id: Optional[int] = None

@router.post("/events/")
async def create_event(event: EventCreate, db=Depends(get_db)):
    cursor, connection = db
    
    cursor.execute("SELECT user_id FROM users WHERE user_id = %s", (event.user_id,))
    if not cursor.fetchone():
        raise HTTPException(status_code=404, detail="User not found")
    
    if event.course_id:
        cursor.execute("SELECT course_id FROM courses WHERE course_id = %s", (event.course_id,))
        if not cursor.fetchone():
            raise HTTPException(status_code=404, detail="Course not found")
    
    query = """
    INSERT INTO calendar_events (title, date, time, description, type, user_id, course_id)
    VALUES (%s, %s, %s, %s, %s, %s, %s)
    """
    cursor.execute(query, (
        event.title, 
        event.date, 
        event.time, 
        event.description, 
        event.type, 
        event.user_id,
        event.course_id
    ))
    connection.commit()
    
    event_id = cursor.lastrowid
    
    return {
        "event_id": event_id,
        "title": event.title,
        "date": event.date,
        "time": event.time,
        "description": event.description,
        "type": event.type,
        "user_id": event.user_id,
        "course_id": event.course_id
    }

@router.get("/events/")
async def get_events(db=Depends(get_db)):
    cursor, _ = db
    query = """
    SELECT e.event_id, e.title, e.date, e.time, e.description, e.type, e.user_id, e.course_id, 
           u.name as user_name, c.course_name
    FROM calendar_events e
    JOIN users u ON e.user_id = u.user_id
    LEFT JOIN courses c ON e.course_id = c.course_id
    ORDER BY e.date, e.time
    """
    cursor.execute(query)
    events = cursor.fetchall()
    
    return [
        {
            "event_id": event["event_id"],
            "title": event["title"],
            "date": event["date"],
            "time": event["time"],
            "description": event["description"],
            "type": event["type"],
            "user_id": event["user_id"],
            "course_id": event["course_id"],
            "user_name": event["user_name"],
            "course_name": event["course_name"]
        }
        for event in events
    ]

@router.get("/events/user/{user_id}")
async def get_user_events(user_id: int, db=Depends(get_db)):
    cursor, _ = db
    
    cursor.execute("SELECT user_id FROM users WHERE user_id = %s", (user_id,))
    if not cursor.fetchone():
        raise HTTPException(status_code=404, detail="User not found")
    
    query = """
    SELECT e.event_id, e.title, e.date, e.time, e.description, e.type, e.user_id, e.course_id,
           u.name as user_name, c.course_name
    FROM calendar_events e
    JOIN users u ON e.user_id = u.user_id
    LEFT JOIN courses c ON e.course_id = c.course_id
    WHERE e.user_id = %s
    ORDER BY e.date, e.time
    """
    cursor.execute(query, (user_id,))
    events = cursor.fetchall()
    
    return [
        {
            "event_id": event["event_id"],
            "title": event["title"],
            "date": event["date"],
            "time": event["time"],
            "description": event["description"],
            "type": event["type"],
            "user_id": event["user_id"],
            "course_id": event["course_id"],
            "user_name": event["user_name"],
            "course_name": event["course_name"]
        }
        for event in events
    ]

@router.get("/events/{event_id}")
async def get_event(event_id: int, db=Depends(get_db)):
    cursor, _ = db
    query = """
    SELECT e.event_id, e.title, e.date, e.time, e.description, e.type, e.user_id, e.course_id,
           u.name as user_name, c.course_name
    FROM calendar_events e
    JOIN users u ON e.user_id = u.user_id
    LEFT JOIN courses c ON e.course_id = c.course_id
    WHERE e.event_id = %s
    """
    cursor.execute(query, (event_id,))
    event = cursor.fetchone()
    
    if not event:
        raise HTTPException(status_code=404, detail="Event not found")
    
    return {
        "event_id": event["event_id"],
        "title": event["title"],
        "date": event["date"],
        "time": event["time"],
        "description": event["description"],
        "type": event["type"],
        "user_id": event["user_id"],
        "course_id": event["course_id"],
        "user_name": event["user_name"],
        "course_name": event["course_name"]
    }

@router.put("/events/{event_id}")
async def update_event(event_id: int, event_update: EventUpdate, db=Depends(get_db)):
    cursor, connection = db
    
    cursor.execute("SELECT event_id FROM calendar_events WHERE event_id = %s", (event_id,))
    if not cursor.fetchone():
        raise HTTPException(status_code=404, detail="Event not found")
    
    if event_update.course_id is not None:
        cursor.execute("SELECT course_id FROM courses WHERE course_id = %s", (event_update.course_id,))
        if not cursor.fetchone():
            raise HTTPException(status_code=404, detail="Course not found")
    
    update_fields = []
    params = []
    
    if event_update.title is not None:
        update_fields.append("title = %s")
        params.append(event_update.title)
    
    if event_update.date is not None:
        update_fields.append("date = %s")
        params.append(event_update.date)
    
    if event_update.time is not None:
        update_fields.append("time = %s")
        params.append(event_update.time)
    
    if event_update.description is not None:
        update_fields.append("description = %s")
        params.append(event_update.description)
    
    if event_update.type is not None:
        update_fields.append("type = %s")
        params.append(event_update.type)
        
    if event_update.course_id is not None:
        update_fields.append("course_id = %s")
        params.append(event_update.course_id)
    
    if not update_fields:
        return {"message": "No fields to update"}
    
    params.append(event_id)
    
    query = f"""
    UPDATE calendar_events
    SET {', '.join(update_fields)}
    WHERE event_id = %s
    """
    cursor.execute(query, params)
    connection.commit()
    
    return {"message": "Event updated successfully"}

@router.delete("/events/{event_id}")
async def delete_event(event_id: int, db=Depends(get_db)):
    cursor, connection = db
    
    cursor.execute("SELECT event_id FROM calendar_events WHERE event_id = %s", (event_id,))
    if not cursor.fetchone():
        raise HTTPException(status_code=404, detail="Event not found")
    
    query = "DELETE FROM calendar_events WHERE event_id = %s"
    cursor.execute(query, (event_id,))
    connection.commit()
    
    return {"message": "Event deleted successfully"}

@router.get("/events/course/{course_id}")
async def get_course_events(course_id: int, db=Depends(get_db)):
    cursor, _ = db
    
    cursor.execute("SELECT course_id FROM courses WHERE course_id = %s", (course_id,))
    if not cursor.fetchone():
        return []
    
    query = """
    SELECT e.event_id, e.title, e.date, e.time, e.description, e.type, e.user_id, e.course_id, 
           u.name as user_name, c.course_name
    FROM calendar_events e
    JOIN users u ON e.user_id = u.user_id
    JOIN courses c ON e.course_id = c.course_id
    WHERE e.course_id = %s
    ORDER BY e.date, e.time
    """
    cursor.execute(query, (course_id,))
    events = cursor.fetchall()
    
    if not events:
        return []
    
    return [
        {
            "event_id": event["event_id"],
            "title": event["title"],
            "date": event["date"],
            "time": event["time"],
            "description": event["description"],
            "type": event["type"],
            "user_id": event["user_id"],
            "course_id": event["course_id"],
            "user_name": event["user_name"],
            "course_name": event["course_name"]
        }
        for event in events
    ] 