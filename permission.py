from fastapi import APIRouter, HTTPException, Depends, Query, Request
from sqlalchemy.orm import Session
from ..database import get_db
from ..models.permission import Permission
from ..schemas import PermissionCreate
from datetime import date
from fastapi.responses import JSONResponse

import os
import json

router = APIRouter(
    tags=["Permission"]
)

# ✅ POST: Grant Permission by HOD
@router.post("/allow")
def allow_permission(permission: PermissionCreate, db: Session = Depends(get_db)):
    existing = db.query(Permission).filter_by(
        semester=permission.semester,
        subject=permission.subject,
        teacher_id=permission.teacher_id,
        date=permission.date
    ).first()

    if existing:
        raise HTTPException(status_code=400, detail="Permission already exists")

    db_permission = Permission(
        semester=permission.semester,
        subject=permission.subject,
        teacher_id=permission.teacher_id,
        date=permission.date
    )
    db.add(db_permission)
    db.commit()
    db.refresh(db_permission)
    return {"message": "Permission granted successfully"}

# ✅ GET: Check if permission is allowed
@router.get("/check")
def check_permission(
    semester: str = Query(...),
    subject: str = Query(...),
    teacher_id: str = Query(...),
    date: date = Query(...),
    db: Session = Depends(get_db)
):
    permission = db.query(Permission).filter_by(
        semester=semester,
        subject=subject,
        teacher_id=teacher_id,
        date=date
    ).first()

    if not permission:
        raise HTTPException(status_code=403, detail="Attendance not allowed by HOD.")

    return {"allowed": True}

# ✅ POST: Submit Attendance to JSON File
@router.post("/attendance/submit")
async def submit_attendance(request: Request):
    ATTENDANCE_FILE = "attendance.json"
    try:
        data = await request.json()
        new_records = data.get("attendance", [])

        # Read existing data if file exists
        if os.path.exists(ATTENDANCE_FILE):
            with open(ATTENDANCE_FILE, "r") as f:
                existing_data = json.load(f)
        else:
            existing_data = []

        # Merge new attendance records
        existing_data.extend(new_records)

        # Save back to file
        with open(ATTENDANCE_FILE, "w") as f:
            json.dump(existing_data, f, indent=2)

        return {"message": "Attendance saved successfully."}
    except Exception as e:
        return JSONResponse(status_code=500, content={"error": str(e)})
