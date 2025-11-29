# ========================================
# backend/models.py
# ========================================
# SQLAlchemy ORM models for database tables
# These models represent the database structure in Python

from sqlalchemy import Column, Integer, String, Float, Date, Time, Enum, Text, DateTime, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from datetime import datetime
import enum

Base = declarative_base()

# Enums for status fields
class DayOfWeekEnum(enum.Enum):
    MONDAY = "Monday"
    TUESDAY = "Tuesday"
    WEDNESDAY = "Wednesday"
    THURSDAY = "Thursday"
    FRIDAY = "Friday"
    SATURDAY = "Saturday"

class AttendanceStatusEnum(enum.Enum):
    PRESENT = "Present"
    ABSENT = "Absent"
    CANCELLED = "Cancelled"
    NOT_TAKEN = "Not Taken"

# ========================================
# Subject Model
# ========================================
class Subject(Base):
    __tablename__ = "subjects"
    
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    subject_name = Column(String(100), nullable=False)
    subject_code = Column(String(20), unique=True, nullable=False)
    required_percentage = Column(Float, default=75.0)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Relationships
    timetable_entries = relationship("Timetable", back_populates="subject", cascade="all, delete-orphan")
    attendance_records = relationship("Attendance", back_populates="subject", cascade="all, delete-orphan")
    
    def __repr__(self):
        return f"<Subject(id={self.id}, name='{self.subject_name}', code='{self.subject_code}')>"

# ========================================
# Timetable Model
# ========================================
class Timetable(Base):
    __tablename__ = "timetable"
    
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    subject_id = Column(Integer, ForeignKey("subjects.id", ondelete="CASCADE"), nullable=False)
    day_of_week = Column(Enum(DayOfWeekEnum), nullable=False)
    start_time = Column(Time, nullable=False)
    end_time = Column(Time, nullable=False)
    room_number = Column(String(20), nullable=True)
    
    # Relationships
    subject = relationship("Subject", back_populates="timetable_entries")
    
    def __repr__(self):
        return f"<Timetable(id={self.id}, subject_id={self.subject_id}, day='{self.day_of_week}')>"

# ========================================
# Attendance Model
# ========================================
class Attendance(Base):
    __tablename__ = "attendance"
    
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    subject_id = Column(Integer, ForeignKey("subjects.id", ondelete="CASCADE"), nullable=False)
    attendance_date = Column(Date, nullable=False)
    status = Column(Enum(AttendanceStatusEnum), nullable=False)
    remarks = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Relationships
    subject = relationship("Subject", back_populates="attendance_records")
    
    def __repr__(self):
        return f"<Attendance(id={self.id}, subject_id={self.subject_id}, date={self.attendance_date}, status='{self.status}')>"


# ========================================
# OPTIONAL: Database Session Configuration
# ========================================
# If you want to use SQLAlchemy ORM instead of raw MySQL connector
# Uncomment this section and use it in your main.py

"""
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# Database URL
DATABASE_URL = "mysql+mysqlconnector://root:your_password@localhost/attendance_db"

# Create engine
engine = create_engine(DATABASE_URL, echo=True)

# Create session factory
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Dependency for FastAPI
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Create all tables
def init_db():
    Base.metadata.create_all(bind=engine)
"""