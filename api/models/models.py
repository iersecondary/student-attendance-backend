from sqlalchemy import Column, Integer, String, Date, ForeignKey, Boolean
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship

Base = declarative_base()

class Attendance(Base):
    __tablename__ = "attendances"

    id = Column(Integer, primary_key=True, index=True)
    date = Column(Date)
    semester = Column(String)
    subject = Column(String)
    students = relationship("StudentAttendance", back_populates="attendance")


class StudentAttendance(Base):
    __tablename__ = "student_attendance"

    id = Column(Integer, primary_key=True, index=True)
    attendance_id = Column(Integer, ForeignKey("attendances.id"))
    roll_no = Column(String)
    status = Column(String)

    attendance = relationship("Attendance", back_populates="students")


# ✅ UPDATED Permission Model
class Permission(Base):
    __tablename__ = "permissions"

    id = Column(Integer, primary_key=True, index=True)
    semester = Column(String, nullable=False)
    subject = Column(String, nullable=False)
    teacher_id = Column(String, nullable=False)
    date = Column(Date, nullable=False)  # Date of permission
    is_allowed = Column(Boolean, default=False)  # ✅ New field
