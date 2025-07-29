from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

router = APIRouter()

# Dummy user data for login testing
users = {
    "admin": "admin",          # For your Flutter test
    "teacher1": "1234",
    "hod": "admin123"
}

class LoginRequest(BaseModel):
    username: str
    password: str

class LoginResponse(BaseModel):
    message: str
    username: str

@router.post("/login", response_model=LoginResponse)
def login_user(request: LoginRequest):
    if request.username in users and users[request.username] == request.password:
        return {"message": "Login successful", "username": request.username}
    else:
        raise HTTPException(status_code=401, detail="Invalid username or password")
