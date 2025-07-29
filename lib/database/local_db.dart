import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

/// Hive imports for mobile only
// ignore: avoid_web_libraries_in_flutter
import 'package:hive_flutter/hive_flutter.dart';

class LocalDatabase {
  static Future<void> initDatabase() async {
    if (!kIsWeb) {
      await Hive.initFlutter();
      await Hive.openBox('attendanceBox');
    } else {
      // Web par kuch nahi karna
      print("Web: Skipping Hive init");
    }
  }

  static Future<void> saveAttendanceLocally(List<Map<String, dynamic>> attendanceList) async {
    if (!kIsWeb) {
      final box = Hive.box('attendanceBox');
      final existing = box.get('pending', defaultValue: []) as List;
      box.put('pending', [...existing, ...attendanceList]);
    } else {
      print("Web: Attendance saved temporarily (not stored)");
    }
  }

  static Future<bool> syncPendingAttendance() async {
    List<Map<String, dynamic>> pendingList = [];

    if (!kIsWeb) {
      final box = Hive.box('attendanceBox');
      final List<dynamic> rawList = box.get('pending', defaultValue: []);
      pendingList = List<Map<String, dynamic>>.from(rawList);
    } else {
      print("Web: Nothing to sync (no local storage)");
      return false;
    }

    if (pendingList.isEmpty) return false;

    try {
      final response = await http.post(
        Uri.parse('http://192.168.100.5:8000/attendance/submit'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'attendance': pendingList}),
      );

      if (response.statusCode == 200) {
        if (!kIsWeb) {
          final box = Hive.box('attendanceBox');
          box.put('pending', []);
        }
        return true;
      } else {
        print("Sync failed: ${response.statusCode}");
      }
    } catch (e) {
      print('Sync error: $e');
    }

    return false;
  }
}
