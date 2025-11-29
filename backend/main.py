from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from schemas import *
import crud
from datetime import date

app = FastAPI(title="Attendance Calculator API")

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Health check
@app.get("/")
def read_root():
    return {"message": "Attendance Calculator API is running"}

# ===== SUBJECT ENDPOINTS =====

@app.post("/api/subjects", response_model=dict)
def create_subject(subject: SubjectCreate):
    subject_id = crud.create_subject(
        subject.subject_name,
        subject.subject_code,
        subject.required_percentage
    )
    if not subject_id:
        raise HTTPException(status_code=500, detail="Failed to create subject")
    return {"id": subject_id, "message": "Subject created successfully"}

@app.get("/api/subjects")
def get_subjects():
    subjects = crud.get_all_subjects()
    return subjects or []

@app.get("/api/subjects/{subject_id}")
def get_subject(subject_id: int):
    subject = crud.get_subject(subject_id)
    if not subject:
        raise HTTPException(status_code=404, detail="Subject not found")
    return subject

@app.delete("/api/subjects/{subject_id}")
def delete_subject(subject_id: int):
    result = crud.delete_subject(subject_id)
    if result is None:
        raise HTTPException(status_code=500, detail="Failed to delete subject")
    return {"message": "Subject deleted successfully"}

# ===== TIMETABLE ENDPOINTS =====

@app.post("/api/timetable")
def create_timetable(entry: TimetableCreate):
    entry_id = crud.create_timetable_entry(
        entry.subject_id,
        entry.day_of_week.value,
        entry.start_time,
        entry.end_time,
        entry.room_number
    )
    if not entry_id:
        raise HTTPException(status_code=500, detail="Failed to create timetable entry")
    return {"id": entry_id, "message": "Timetable entry created successfully"}

@app.get("/api/timetable")
def get_timetable():
    timetable = crud.get_timetable()
    return timetable or []

@app.get("/api/timetable/day/{day}")
def get_timetable_by_day(day: str):
    timetable = crud.get_timetable_by_day(day)
    return timetable or []

# ===== ATTENDANCE ENDPOINTS =====

@app.post("/api/attendance")
def mark_attendance(attendance: AttendanceCreate):
    result = crud.mark_attendance(
        attendance.subject_id,
        str(attendance.attendance_date),
        attendance.status.value,
        attendance.remarks
    )
    if result is None:
        raise HTTPException(status_code=500, detail="Failed to mark attendance")
    return {"message": "Attendance marked successfully"}

@app.get("/api/attendance/subject/{subject_id}")
def get_attendance_by_subject(subject_id: int):
    attendance = crud.get_attendance_by_subject(subject_id)
    return attendance or []

@app.get("/api/attendance/date/{attendance_date}")
def get_attendance_by_date(attendance_date: date):
    attendance = crud.get_attendance_by_date(str(attendance_date))
    return attendance or []

# ===== ANALYTICS ENDPOINTS =====

@app.get("/api/analytics/subject/{subject_id}")
def get_subject_analytics(subject_id: int):
    analytics = crud.calculate_analytics(subject_id)
    if not analytics:
        raise HTTPException(status_code=404, detail="Subject not found or no data")
    return analytics

@app.get("/api/analytics/overall")
def get_overall_analytics():
    return crud.get_overall_analytics()