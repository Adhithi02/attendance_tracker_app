import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/subject.dart';
import '../models/timetable.dart';
import '../models/attendance.dart';

class ApiService {
  // Change this to your computer's IP address
  static const String baseUrl = 'http://xxx.xxx.x.xx:8000/api';

  // ===== SUBJECT METHODS =====
  
  static Future<List<Subject>> getSubjects() async {
    final response = await http.get(Uri.parse('$baseUrl/subjects'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Subject.fromJson(data as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load subjects');
    }
  }

  static Future createSubject(Subject subject) async {
    final response = await http.post(
      Uri.parse('$baseUrl/subjects'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(subject.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create subject');
    }
  }

  static Future deleteSubject(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/subjects/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete subject');
    }
  }

  // ===== TIMETABLE METHODS =====
  
  static Future<List<TimetableEntry>> getTimetable() async {
    final response = await http.get(Uri.parse('$baseUrl/timetable'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => TimetableEntry.fromJson(data as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load timetable');
    }
  }

  static Future createTimetableEntry(TimetableEntry entry) async {
    final response = await http.post(
      Uri.parse('$baseUrl/timetable'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(entry.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create timetable entry');
    }
  }

  // ===== ATTENDANCE METHODS =====
  
  static Future markAttendance(Attendance attendance) async {
    final response = await http.post(
      Uri.parse('$baseUrl/attendance'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(attendance.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to mark attendance');
    }
  }

  static Future<List<Attendance>> getAttendanceBySubject(int subjectId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/attendance/subject/$subjectId'),
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Attendance.fromJson(data as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load attendance');
    }
  }

  // ===== ANALYTICS METHODS =====
  
  static Future<Analytics> getSubjectAnalytics(int subjectId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/analytics/subject/$subjectId'),
    );
    if (response.statusCode == 200) {
      return Analytics.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load analytics');
    }
  }

  static Future<Map<String, dynamic>> getOverallAnalytics() async {
    final response = await http.get(
      Uri.parse('$baseUrl/analytics/overall'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load overall analytics');
    }
  }
}