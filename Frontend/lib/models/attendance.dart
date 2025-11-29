class Attendance {
  final int? id;
  final int subjectId;
  final DateTime attendanceDate;
  final String status;
  final String? remarks;
  final String? subjectName;

  Attendance({
    this.id,
    required this.subjectId,
    required this.attendanceDate,
    required this.status,
    this.remarks,
    this.subjectName,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      subjectId: json['subject_id'],
      attendanceDate: DateTime.parse(json['attendance_date']),
      status: json['status'],
      remarks: json['remarks'],
      subjectName: json['subject_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject_id': subjectId,
      'attendance_date': attendanceDate.toIso8601String().split('T')[0],
      'status': status,
      'remarks': remarks,
    };
  }
}

class Analytics {
  final int subjectId;
  final String subjectName;
  final int totalClasses;
  final int attended;
  final double percentage;
  final int classesNeeded;
  final int classesCanMiss;

  Analytics({
    required this.subjectId,
    required this.subjectName,
    required this.totalClasses,
    required this.attended,
    required this.percentage,
    required this.classesNeeded,
    required this.classesCanMiss,
  });

  factory Analytics.fromJson(Map<String, dynamic> json) {
    return Analytics(
      subjectId: json['subject_id'],
      subjectName: json['subject_name'],
      totalClasses: json['total_classes'],
      attended: json['attended'],
      percentage: (json['percentage'] as num).toDouble(),
      classesNeeded: json['classes_needed'],
      classesCanMiss: json['classes_can_miss'],
    );
  }
}