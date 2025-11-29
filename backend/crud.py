from database import execute_query
import math

# Subject CRUD
def create_subject(subject_name: str, subject_code: str, required_percentage: float):
    query = """
        INSERT INTO subjects (subject_name, subject_code, required_percentage)
        VALUES (%s, %s, %s)
    """
    return execute_query(query, (subject_name, subject_code, required_percentage))

def get_all_subjects():
    query = "SELECT * FROM subjects"
    return execute_query(query, fetch=True)

def get_subject(subject_id: int):
    query = "SELECT * FROM subjects WHERE id = %s"
    result = execute_query(query, (subject_id,), fetch=True)
    return result[0] if result else None

def delete_subject(subject_id: int):
    query = "DELETE FROM subjects WHERE id = %s"
    return execute_query(query, (subject_id,))

# Timetable CRUD
def create_timetable_entry(subject_id: int, day_of_week: str, start_time: str, 
                          end_time: str, room_number: str):
    query = """
        INSERT INTO timetable (subject_id, day_of_week, start_time, end_time, room_number)
        VALUES (%s, %s, %s, %s, %s)
    """
    return execute_query(query, (subject_id, day_of_week, start_time, end_time, room_number))

def get_timetable():
    query = """
        SELECT t.*, s.subject_name, s.subject_code
        FROM timetable t
        JOIN subjects s ON t.subject_id = s.id
        ORDER BY FIELD(t.day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'),
                 t.start_time
    """
    return execute_query(query, fetch=True)

def get_timetable_by_day(day: str):
    query = """
        SELECT t.*, s.subject_name, s.subject_code
        FROM timetable t
        JOIN subjects s ON t.subject_id = s.id
        WHERE t.day_of_week = %s
        ORDER BY t.start_time
    """
    return execute_query(query, (day,), fetch=True)

# Attendance CRUD
def mark_attendance(subject_id: int, attendance_date: str, status: str, remarks: str = None):
    query = """
        INSERT INTO attendance (subject_id, attendance_date, status, remarks)
        VALUES (%s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE status = VALUES(status), remarks = VALUES(remarks)
    """
    return execute_query(query, (subject_id, attendance_date, status, remarks))

def get_attendance_by_subject(subject_id: int):
    query = """
        SELECT * FROM attendance
        WHERE subject_id = %s
        ORDER BY attendance_date DESC
    """
    return execute_query(query, (subject_id,), fetch=True)

def get_attendance_by_date(attendance_date: str):
    query = """
        SELECT a.*, s.subject_name
        FROM attendance a
        JOIN subjects s ON a.subject_id = s.id
        WHERE a.attendance_date = %s
    """
    return execute_query(query, (attendance_date,), fetch=True)

# Analytics
def calculate_analytics(subject_id: int):
    query = """
        SELECT 
            s.id as subject_id,
            s.subject_name,
            s.required_percentage,
            COUNT(a.id) as total_classes,
            SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) as attended
        FROM subjects s
        LEFT JOIN attendance a ON s.id = a.subject_id 
            AND a.status NOT IN ('Cancelled', 'Not Taken')
        WHERE s.id = %s
        GROUP BY s.id
    """
    result = execute_query(query, (subject_id,), fetch=True)
    
    if not result or not result[0]:
        return None
    
    data = result[0]
    total = data['total_classes'] or 0
    attended = data['attended'] or 0
    required = data['required_percentage'] / 100
    
    # Calculate percentage
    percentage = (attended / total * 100) if total > 0 else 0
    
    # Calculate classes needed to reach target
    if percentage >= data['required_percentage']:
        classes_needed = 0
    else:
        classes_needed = math.ceil((required * total - attended) / (1 - required)) if required < 1 else float('inf')
    
    # Calculate classes can miss
    classes_can_miss = math.floor((attended - required * total) / required) if total > 0 else 0
    classes_can_miss = max(0, classes_can_miss)
    
    return {
        'subject_id': data['subject_id'],
        'subject_name': data['subject_name'],
        'total_classes': total,
        'attended': attended,
        'percentage': round(percentage, 2),
        'classes_needed': classes_needed,
        'classes_can_miss': classes_can_miss
    }

def get_overall_analytics():
    query = """
        SELECT 
            COUNT(DISTINCT a.id) as total_classes,
            SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) as attended
        FROM attendance a
        WHERE a.status NOT IN ('Cancelled', 'Not Taken')
    """
    result = execute_query(query, fetch=True)
    
    if not result or not result[0]:
        return {'total_classes': 0, 'attended': 0, 'percentage': 0}
    
    data = result[0]
    total = data['total_classes'] or 0
    attended = data['attended'] or 0
    percentage = (attended / total * 100) if total > 0 else 0
    
    return {
        'total_classes': total,
        'attended': attended,
        'percentage': round(percentage, 2)
    }