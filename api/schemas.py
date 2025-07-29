from pydantic import BaseModel
from typing import List
from datetime import date  # ✅ Correct import added

# ✅ Student Attendance detail
class StudentAttendance(BaseModel):
    roll_no: str
    status: str  # present or absent

# ✅ Attendance mark request (from teacher)
class AttendanceRequest(BaseModel):
    date: date  # ✅ changed from str to date
    semester: str
    subject: str
    students: List[StudentAttendance]

# ✅ NEW SCHEMA: For Attendance Permission by HOD
class PermissionCreate(BaseModel):
    semester: str
    subject: str
    teacher_id: int
    date: date  # ✅ changed from str to date

# ✅ NEW SCHEMA: For Checking Permission (used by teacher app)
class PermissionCheck(BaseModel):
    semester: str
    subject: str
    teacher_id: int
    date: date  # ✅ changed from str to date
