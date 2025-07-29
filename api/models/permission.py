from sqlalchemy import Column, Integer, String, Date
from api.database import Base

class Permission(Base):
    __tablename__ = "permissions"

    id = Column(Integer, primary_key=True, index=True)
    semester = Column(String, nullable=False)
    subject = Column(String, nullable=False)
    teacher_id = Column(Integer, nullable=False)
    date = Column(Date, nullable=False)
