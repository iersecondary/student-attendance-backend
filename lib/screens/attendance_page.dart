import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../database/local_db.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String selectedSemester = 'Semester 1';
  String selectedSubject = 'Math';
  Map<String, bool> studentAttendance = {
    'Student A': false,
    'Student B': false,
    'Student C': false,
  };

  final List<String> semesters = [
    'Semester 1',
    'Semester 3',
    'Semester 5',
    'Semester 7',
  ];

  final List<String> subjects = [
    'Math',
    'Science',
    'History',
    'English',
    'Computer',
  ];

  Future<bool> checkPermission(String semester, String subject, String date) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.100.5:8000/permission/check'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'teacher_id': 1, // 🧑‍🏫 Hardcoded for now
          'semester': semester,
          'subject': subject,
          'date': date,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['is_allowed'] == true;
      }
    } catch (e) {
      print("Permission check failed: $e");
    }
    return false;
  }

  Future<void> markAttendance() async {
    final date = DateTime.now().toIso8601String().split("T").first;

    bool permissionGranted = await checkPermission(selectedSemester, selectedSubject, date);
    if (!permissionGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission not granted by HOD.')),
      );
      return;
    }

    List<Map<String, dynamic>> attendanceList = studentAttendance.entries.map((entry) {
      return {
        'semester': selectedSemester,
        'subject': selectedSubject,
        'student_name': entry.key,
        'is_present': entry.value,
        'date': date,
      };
    }).toList();

    final connectivity = await Connectivity().checkConnectivity();

    if (connectivity != ConnectivityResult.none) {
      try {
        final response = await http.post(
          Uri.parse('http://192.168.100.5:8000/attendance/submit'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'attendance': attendanceList}),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Attendance submitted online')),
          );

          await LocalDatabase.syncPendingAttendance();
        } else {
          await LocalDatabase.saveAttendanceLocally(attendanceList);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Server error. Attendance saved locally.')),
          );
        }
      } catch (e) {
        await LocalDatabase.saveAttendanceLocally(attendanceList);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connection failed. Attendance saved locally.')),
        );
      }
    } else {
      await LocalDatabase.saveAttendanceLocally(attendanceList);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No internet. Attendance saved locally.')),
      );
    }

    setState(() {
      studentAttendance.updateAll((key, value) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mark Attendance'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedSemester,
              onChanged: (newValue) {
                setState(() {
                  selectedSemester = newValue!;
                });
              },
              items: semesters.map((semester) {
                return DropdownMenuItem(
                  value: semester,
                  child: Text(semester),
                );
              }).toList(),
            ),
            DropdownButton<String>(
              value: selectedSubject,
              onChanged: (newValue) {
                setState(() {
                  selectedSubject = newValue!;
                });
              },
              items: subjects.map((subject) {
                return DropdownMenuItem(
                  value: subject,
                  child: Text(subject),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: studentAttendance.keys.map((student) {
                  return CheckboxListTile(
                    title: Text(student),
                    value: studentAttendance[student],
                    onChanged: (value) {
                      setState(() {
                        studentAttendance[student] = value!;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: markAttendance,
              child: Text('Submit Attendance'),
            ),
          ],
        ),
      ),
    );
  }
}
