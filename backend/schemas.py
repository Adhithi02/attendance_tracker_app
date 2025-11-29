from pydantic import BaseModel
from typing import Optional
from datetime import date, time
from enum import Enum

class DayOfWeek(str, Enum):
    MONDAY = "Monday"
    TUESDAY = "Tuesday"
    WEDNESDAY = "Wednesday"
    THURSDAY = "Thursday"
    FRIDAY = "Friday"
    SATURDAY = "Saturday"

class AttendanceStatus(str, Enum):
    PRESENT = "Present"
    ABSENT = "Absent"
    CANCELLED = "Cancelled"
    NOT_TAKEN = "Not Taken"

# Subject schemas
class SubjectCreate(BaseModel):
    subject_name: str
    subject_code: str
    required_percentage: float = 75.0

class SubjectResponse(BaseModel):
    id: int
    subject_name: str
    subject_code: str
    required_percentage: float

# Timetable schemas
class TimetableCreate(BaseModel):
    subject_id: int
    day_of_week: DayOfWeek
    start_time: str
    end_time: str
    room_number: Optional[str] = None

class TimetableResponse(BaseModel):
    id: int
    subject_id: int
    day_of_week: str
    start_time: str
    end_time: str
    room_number: Optional[str]

# Attendance schemas
class AttendanceCreate(BaseModel):
    subject_id: int
    attendance_date: date
    status: AttendanceStatus
    remarks: Optional[str] = None

class AttendanceResponse(BaseModel):
    id: int
    subject_id: int
    attendance_date: date
    status: str
    remarks: Optional[str]

# Analytics schema
class AnalyticsResponse(BaseModel):
    subject_id: int
    subject_name: str
    total_classes: int
    attended: int
    percentage: float
    classes_needed: int
    classes_can_miss: int