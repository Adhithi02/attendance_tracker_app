class TimetableEntry {
  final int? id;
  final int subjectId;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final String? roomNumber;
  final String? subjectName;
  final String? subjectCode;

  TimetableEntry({
    this.id,
    required this.subjectId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.roomNumber,
    this.subjectName,
    this.subjectCode,
  });

  factory TimetableEntry.fromJson(Map<String, dynamic> json) {
    return TimetableEntry(
      id: json['id'],
      subjectId: json['subject_id'],
      dayOfWeek: json['day_of_week'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      roomNumber: json['room_number'],
      subjectName: json['subject_name'],
      subjectCode: json['subject_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject_id': subjectId,
      'day_of_week': dayOfWeek,
      'start_time': startTime,
      'end_time': endTime,
      'room_number': roomNumber,
    };
  }
}