import 'package:flutter/material.dart';

class AttendanceProgressBar extends StatelessWidget {
  final double percentage;
  final double requiredPercentage;

  const AttendanceProgressBar({
    super.key,
    required this.percentage,
    this.requiredPercentage = 75.0,
  });

  @override
  Widget build(BuildContext context) {
    Color getColor() {
      if (percentage >= requiredPercentage + 10) return Colors.green;
      if (percentage >= requiredPercentage) return Colors.lightGreen;
      if (percentage >= requiredPercentage - 5) return Colors.orange;
      return Colors.red;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: getColor(),
              ),
            ),
            Text(
              'Target: ${requiredPercentage.toInt()}%',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 10,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(getColor()),
          ),
        ),
      ],
    );
  }
}