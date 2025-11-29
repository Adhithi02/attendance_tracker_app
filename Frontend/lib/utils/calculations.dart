import 'dart:math';

class AttendanceCalculations {
  /// Calculate attendance percentage
  static double calculatePercentage(int attended, int total) {
    if (total == 0) return 0;
    return (attended / total) * 100;
  }

  /// Calculate classes needed to reach target percentage
  static int calculateClassesNeeded(
    int attended,
    int total,
    double requiredPercentage,
  ) {
    if (total == 0) return 0;
    
    final currentPercentage = calculatePercentage(attended, total);
    if (currentPercentage >= requiredPercentage) return 0;

    final required = requiredPercentage / 100;
    final classesNeeded = ((required * total - attended) / (1 - required));
    
    return classesNeeded.ceil();
  }

  /// Calculate how many classes can be missed while staying above threshold
  static int calculateClassesCanMiss(
    int attended,
    int total,
    double requiredPercentage,
  ) {
    if (total == 0) return 0;
    
    final required = requiredPercentage / 100;
    final canMiss = (attended - required * total) / required;
    
    return max(0, canMiss.floor());
  }

  /// Get attendance status color
  static String getAttendanceStatus(double percentage, double required) {
    if (percentage >= required + 10) return 'Excellent';
    if (percentage >= required) return 'Good';
    if (percentage >= required - 5) return 'Warning';
    return 'Critical';
  }
}