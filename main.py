from fastapi import FastAPI
from api import schemas
from fastapi.middleware.cors import CORSMiddleware
from api.router import permission  # ✅ Permission router
from api.router import login       # ✅ Login router

app = FastAPI()

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(permission.router, prefix="/permission")  # ✅ For HOD permissions
app.include_router(login.router, prefix="/auth")             # ✅ For login

@app.post("/attendance/submit")
def submit_attendance(attendance: schemas.AttendanceRequest):
    print("Attendance Received:")
    print(attendance)
    return {"message": "Attendance submitted successfully"}
