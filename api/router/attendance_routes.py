from fastapi import APIRouter, Request
from pydantic import BaseModel

router = APIRouter()

# Attendance data model
class Attendance(BaseModel):
    semester: str
    subject: str
    date: str
    attendance: list  # e.g. [{"name": "Ali", "status": "Present"}]

# Sample POST route for attendance submission
@router.post("/submit")
async def submit_attendance(attendance: Attendance, request: Request):
    # You can log or print the attendance to see what you receive
    print("Attendance received:", attendance)
    
    # Sample response
    return {"message": "Attendance submitted successfully", "data": attendance}
