# api/create_db.py

from api.database import engine
from api.models.permission import Base

def create_tables():
    print("Creating tables...")
    Base.metadata.create_all(bind=engine)
    print("✅ Tables created successfully.")

if __name__ == "__main__":
    create_tables()
