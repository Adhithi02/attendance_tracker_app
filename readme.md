# 📱 Attendance Calculator App - Complete Setup Guide

## 📋 Table of Contents
1. [Prerequisites](#prerequisites)
2. [Project Structure](#project-structure)
3. [Database Setup](#database-setup)
4. [Backend Setup](#backend-setup)
5. [Flutter App Setup](#flutter-app-setup)
6. [Running the Application](#running-the-application)
7. [Testing](#testing)
8. [Troubleshooting](#troubleshooting)
9. [Features](#features)

---

## 🔧 Prerequisites

### Required Software:
- **MySQL Server** (8.0 or higher)
- **Python** (3.8 or higher)
- **Flutter SDK** (3.0 or higher)
- **Android Studio** or **VS Code** with Flutter extensions
- **Android Emulator** or Physical Android Device
- **Git** (optional)

### Installation Links:
- MySQL: https://dev.mysql.com/downloads/
- Python: https://www.python.org/downloads/
- Flutter: https://docs.flutter.dev/get-started/install
- Android Studio: https://developer.android.com/studio

---

## 📁 Project Structure

```
attendance_calculator/
│
├── backend/                     # FastAPI Backend
│   ├── main.py                 # Main API server
│   ├── database.py             # Database connection
│   ├── schemas.py              # Pydantic models
│   ├── crud.py                 # Database operations
│   ├── requirements.txt        # Python dependencies
│   └── init_db.sql            # Database initialization
│
├── mobile_app/                 # Flutter Frontend
│   ├── lib/
│   │   ├── main.dart          # App entry point
│   │   ├── models/            # Data models
│   │   │   ├── subject.dart
│   │   │   ├── timetable.dart
│   │   │   └── attendance.dart
│   │   ├── services/          # API services
│   │   │   └── api_service.dart
│   │   ├── screens/           # UI screens
│   │   │   ├── dashboard_screen.dart
│   │   │   ├── subjects_screen.dart
│   │   │   ├── timetable_screen.dart
│   │   │   ├── attendance_screen.dart
│   │   │   └── analytics_screen.dart
│   │   ├── widgets/           # Reusable widgets
│   │   │   ├── subject_card.dart
│   │   │   ├── attendance_button.dart
│   │   │   └── progress_bar.dart
│   │   └── utils/             # Helper functions
│   │       └── calculations.dart
│   ├── pubspec.yaml           # Flutter dependencies
│   └── android/
│
└── README.md                   # This file
```

---

## 🗄️ Database Setup

### Step 1: Install MySQL

**Windows:**
```bash
# Download MySQL Installer from https://dev.mysql.com/downloads/installer/
# Follow installation wizard
# Remember your root password!
```

**Mac:**
```bash
brew install mysql
mysql.server start
```

**Linux:**
```bash
sudo apt-get update
sudo apt-get install mysql-server
sudo systemctl start mysql
```

### Step 2: Secure MySQL Installation

```bash
sudo mysql_secure_installation
```

### Step 3: Create Database

**Option 1: Using MySQL Command Line**

```bash
# Login to MySQL
mysql -u root -p

# Create database
CREATE DATABASE attendance_db;

# Exit MySQL
exit;
```

**Option 2: Using MySQL Workbench**
1. Open MySQL Workbench
2. Connect to your local server
3. Create new schema named `attendance_db`

### Step 4: Run Initialization Script

```bash
# Navigate to backend folder
cd backend

# Run the SQL script
mysql -u root -p attendance_db < init_db.sql
```

### Step 5: Verify Database

```bash
mysql -u root -p

USE attendance_db;

SHOW TABLES;
# Should show: subjects, timetable, attendance

SELECT * FROM subjects;
# Should show sample data

exit;
```

---

## 🔧 Backend Setup

### Step 1: Navigate to Backend Folder

```bash
cd backend
```

### Step 2: Create Virtual Environment (Recommended)

**Windows:**
```bash
python -m venv venv
venv\Scripts\activate
```

**Mac/Linux:**
```bash
python3 -m venv venv
source venv/bin/activate
```

### Step 3: Install Dependencies

```bash
pip install -r requirements.txt
```

If you don't have requirements.txt, install manually:
```bash
pip install fastapi uvicorn mysql-connector-python pydantic python-dotenv
```

### Step 4: Configure Database Connection

Edit `backend/database.py`:

```python
def get_db_connection():
    try:
        connection = mysql.connector.connect(
            host='localhost',
            database='attendance_db',
            user='root',              # Change this to your MySQL username
            password='YOUR_PASSWORD'  # Change this to your MySQL password
        )
        return connection
    except Error as e:
        print(f"Error: {e}")
        return None
```

### Step 5: Test Backend

```bash
# Run the server
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

You should see:
```
INFO:     Uvicorn running on http://0.0.0.0:8000
INFO:     Application startup complete.
```

### Step 6: Test API

Open browser and visit:
- **API Docs**: http://localhost:8000/docs
- **Root Endpoint**: http://localhost:8000/

You should see automatic API documentation!

---

## 📱 Flutter App Setup

### Step 1: Verify Flutter Installation

```bash
flutter doctor
```

Fix any issues shown.

### Step 2: Navigate to Mobile App Folder

```bash
cd mobile_app
```

### Step 3: Install Dependencies

```bash
flutter pub get
```

### Step 4: Find Your Computer's IP Address

You need this for the Flutter app to connect to your backend.

**Windows:**
```bash
ipconfig
# Look for "IPv4 Address" under your active network
# Example: 192.168.1.100
```

**Mac/Linux:**
```bash
ifconfig
# Look for "inet" under en0 or wlan0
# Example: 192.168.1.100
```

**Important**: Do NOT use `localhost` or `127.0.0.1` - these won't work from mobile device/emulator!

### Step 5: Update API Base URL

Edit `lib/services/api_service.dart`:

```dart
class ApiService {
  // Replace with YOUR computer's IP address
  static const String baseUrl = 'http://192.168.1.100:8000/api';
  
  // Rest of the code...
}
```

### Step 6: Configure Android Permissions

Edit `android/app/src/main/AndroidManifest.xml`:

Add inside `<manifest>` tag:
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

### Step 7: Build and Run

```bash
# Check connected devices
flutter devices

# Run on connected device/emulator
flutter run
```

**Or** open in Android Studio:
1. Open the `mobile_app` folder
2. Click Run button
3. Select device/emulator

---

## 🚀 Running the Application

### Complete Startup Sequence:

**Terminal 1: Start Backend**
```bash
cd backend
source venv/bin/activate  # or venv\Scripts\activate on Windows
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

**Terminal 2: Start Flutter App**
```bash
cd mobile_app
flutter run
```

### First Time Usage:

1. **Add Subjects**
   - Go to "Subjects" tab
   - Click + button
   - Add your subjects (e.g., Mathematics, Physics)

2. **Create Timetable**
   - Go to "Timetable" tab
   - Click + button
   - Add classes for each day

3. **Mark Attendance**
   - Go to "Attendance" tab
   - Select today's date
   - Mark Present/Absent for each subject

4. **View Analytics**
   - Go to "Dashboard"
   - See overall attendance
   - Click "View Analytics" for detailed insights

---

## 🧪 Testing

### Test Backend APIs

Using the auto-generated docs at http://localhost:8000/docs:

**Test 1: Create Subject**
```json
POST /api/subjects
{
  "subject_name": "Test Subject",
  "subject_code": "TEST101",
  "required_percentage": 75
}
```

**Test 2: Get All Subjects**
```
GET /api/subjects
```

**Test 3: Mark Attendance**
```json
POST /api/attendance
{
  "subject_id": 1,
  "attendance_date": "2025-11-28",
  "status": "Present"
}
```

### Test Flutter App

1. **Add Subject**: Subjects tab → + button
2. **Add Timetable**: Timetable tab → + button
3. **Mark Attendance**: Attendance tab → Select subject → Mark status
4. **View Analytics**: Dashboard → View Analytics

---

## 🔍 Troubleshooting

### Common Issues:

#### 1. Backend Won't Start

**Error**: `mysql.connector.errors.ProgrammingError: Access denied`

**Solution**:
```python
# Check database.py credentials
user='root',
password='YOUR_ACTUAL_PASSWORD'
```

#### 2. Flutter Can't Connect to Backend

**Error**: `SocketException: Connection refused`

**Solution**:
- Verify backend is running (check terminal)
- Use computer's IP address, NOT localhost
- Check firewall isn't blocking port 8000
- Ensure phone/emulator is on same WiFi network

```dart
// WRONG
static const String baseUrl = 'http://localhost:8000/api';

// RIGHT
static const String baseUrl = 'http://192.168.1.100:8000/api';
```

#### 3. Database Connection Error

**Error**: `Can't connect to MySQL server`

**Solution**:
```bash
# Check if MySQL is running
# Windows
net start MySQL

# Mac
mysql.server start

# Linux
sudo systemctl start mysql
```

#### 4. Flutter Dependencies Error

**Error**: `Package not found`

**Solution**:
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

#### 5. Android Build Error

**Error**: `Gradle build failed`

**Solution**:
```bash
cd android
./gradlew clean  # Mac/Linux
gradlew clean    # Windows
cd ..
flutter run
```

### Debug Mode:

**Backend Logs**:
```bash
# Check terminal where uvicorn is running
# You'll see all API requests and errors
```

**Flutter Logs**:
```bash
# In terminal where flutter run is active
# Or in Android Studio's "Run" tab
```

---

## ✨ Features

### Current Features:

✅ **Subject Management**
- Add/delete subjects
- Set custom attendance thresholds
- Subject codes and names

✅ **Timetable Management**
- Weekly schedule
- Multiple classes per day
- Room number tracking

✅ **Attendance Tracking**
- Four status types (Present, Absent, Cancelled, Not Taken)
- Date-based marking
- Historical records

✅ **Analytics Dashboard**
- Overall attendance percentage
- Subject-wise breakdown
- Visual progress bars
- Classes needed calculation
- Classes can miss calculation

✅ **Smart Insights**
- Real-time percentage updates
- Alerts for low attendance
- Predictive analytics

### Future Enhancements:

🚧 PDF Report Generation
🚧 Push Notifications
🚧 Cloud Backup
🚧 Multi-user Support
🚧 Calendar Integration
🚧 Dark Mode

---

## 📊 API Endpoints Reference

### Subjects

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/subjects` | Get all subjects |
| POST | `/api/subjects` | Create new subject |
| GET | `/api/subjects/{id}` | Get subject by ID |
| DELETE | `/api/subjects/{id}` | Delete subject |

### Timetable

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/timetable` | Get full timetable |
| POST | `/api/timetable` | Add timetable entry |
| GET | `/api/timetable/day/{day}` | Get classes for specific day |

### Attendance

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/attendance` | Mark attendance |
| GET | `/api/attendance/subject/{id}` | Get attendance by subject |
| GET | `/api/attendance/date/{date}` | Get attendance by date |

### Analytics

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/analytics/subject/{id}` | Get subject analytics |
| GET | `/api/analytics/overall` | Get overall statistics |

---

## 🎓 Usage Tips

### Best Practices:

1. **Set up timetable at start of semester**
2. **Mark attendance daily** - takes just 2 minutes
3. **Check analytics weekly** to stay on track
4. **Enable notifications** for low attendance alerts
5. **Backup data regularly** using export feature

### Formula Reference:

**Attendance Percentage:**
```
Attendance % = (Classes Attended / Total Classes) × 100
```

**Classes Needed:**
```
N = ceil[(Required% × Total - Attended) / (1 - Required%)]
```

**Classes Can Miss:**
```
N = floor[(Attended - Required% × Total) / Required%]
```

---

## 💡 Tips for Presentation

### Demo Script:

1. **Start**: Show dashboard with sample data
2. **Add Subject**: Live demo adding a new subject
3. **Show Timetable**: Display weekly schedule
4. **Mark Attendance**: Quick attendance marking demo
5. **Analytics**: Highlight percentage and predictions
6. **Explain Calculations**: Show the formulas in action

### Key Points to Mention:

- ✅ Solves real student problem
- ✅ Saves time vs manual tracking
- ✅ Provides predictive insights
- ✅ Works offline (local database)
- ✅ Clean, modern UI
- ✅ Complete CRUD operations
- ✅ RESTful API architecture

---

## 📝 Project Report Structure

1. **Abstract** - Brief overview
2. **Introduction** - Problem statement
3. **Literature Review** - Existing solutions
4. **System Design** - Architecture diagrams
5. **Implementation** - Code explanation
6. **Database Design** - ER diagrams, schemas
7. **Testing** - Test cases and results
8. **Results** - Screenshots, analytics
9. **Future Work** - Enhancements
10. **Conclusion** - Summary and impact

---

## 📞 Support

For issues or questions:
- Check [Troubleshooting](#troubleshooting) section
- Review API docs: http://localhost:8000/docs
- Check Flutter logs: `flutter run -v`

---

## 🎉 Success Checklist

Before presenting, ensure:

- [ ] MySQL is running
- [ ] Backend server is running on port 8000
- [ ] API docs are accessible at /docs
- [ ] Flutter app connects to backend
- [ ] Sample data is loaded
- [ ] All screens work properly
- [ ] Calculations are accurate
- [ ] No console errors
- [ ] Demo script is prepared
- [ ] Screenshots are ready

---

## 📄 License

This project is for educational purposes.

---

