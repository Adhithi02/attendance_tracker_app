class Subject {
  final int? id;
  final String subjectName;
  final String subjectCode;
  final double requiredPercentage;

  Subject({
    this.id,
    required this.subjectName,
    required this.subjectCode,
    this.requiredPercentage = 75.0,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      subjectName: json['subject_name'],
      subjectCode: json['subject_code'],
      requiredPercentage: (json['required_percentage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject_name': subjectName,
      'subject_code': subjectCode,
      'required_percentage': requiredPercentage,
    };
  }
}