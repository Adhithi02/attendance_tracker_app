import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/timetable.dart';
import '../models/subject.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  List<TimetableEntry> _timetable = [];
  List<Subject> _subjects = [];
  bool _isLoading = true;

  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final timetable = await ApiService.getTimetable();
      final subjects = await ApiService.getSubjects();
      setState(() {
        _timetable = timetable;
        _subjects = subjects;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  void _showAddEntryDialog() {
    if (_subjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add subjects first')),
      );
      return;
    }

    Subject? selectedSubject = _subjects.first;
    String selectedDay = _days.first;
    final startTimeController = TextEditingController(text: '09:00');
    final endTimeController = TextEditingController(text: '10:00');
    final roomController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Timetable Entry'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<Subject>(
                value: selectedSubject,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(),
                ),
                items: _subjects.map((subject) {
                  return DropdownMenuItem(
                    value: subject,
                    child: Text(subject.subjectName),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedSubject = value;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedDay,
                decoration: const InputDecoration(
                  labelText: 'Day',
                  border: OutlineInputBorder(),
                ),
                items: _days.map((day) {
                  return DropdownMenuItem(
                    value: day,
                    child: Text(day),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) selectedDay = value;
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: startTimeController,
                decoration: const InputDecoration(
                  labelText: 'Start Time (HH:MM)',
                  border: OutlineInputBorder(),
                  hintText: '09:00',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: endTimeController,
                decoration: const InputDecoration(
                  labelText: 'End Time (HH:MM)',
                  border: OutlineInputBorder(),
                  hintText: '10:00',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: roomController,
                decoration: const InputDecoration(
                  labelText: 'Room Number (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (selectedSubject == null) return;

              final entry = TimetableEntry(
                subjectId: selectedSubject!.id!,
                dayOfWeek: selectedDay,
                startTime: startTimeController.text,
                endTime: endTimeController.text,
                roomNumber: roomController.text.isEmpty ? null : roomController.text,
              );

              try {
                await ApiService.createTimetableEntry(entry);
                Navigator.pop(context);
                _loadData();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Entry added successfully')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  List<TimetableEntry> _getEntriesForDay(String day) {
    return _timetable.where((entry) => entry.dayOfWeek == day).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _days.length,
                itemBuilder: (context, index) {
                  final day = _days[index];
                  final entries = _getEntriesForDay(day);
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ExpansionTile(
                      title: Text(
                        day,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text('${entries.length} classes'),
                      children: entries.isEmpty
                          ? [
                              const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  'No classes scheduled',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            ]
                          : entries.map((entry) {
                              return ListTile(
                                leading: CircleAvatar(
                                  child: Text(
                                    entry.startTime.substring(0, 2),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                title: Text(entry.subjectName ?? 'Unknown'),
                                subtitle: Text(
                                  '${entry.startTime} - ${entry.endTime}'
                                  '${entry.roomNumber != null ? ' • ${entry.roomNumber}' : ''}',
                                ),
                                trailing: Text(
                                  entry.subjectCode ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              );
                            }).toList(),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEntryDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
