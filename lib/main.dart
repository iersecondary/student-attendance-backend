import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'screens/login_page.dart';
import 'screens/dashboard_page.dart';
import 'screens/attendance_page.dart';
import 'database/local_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Hive
  await Hive.initFlutter(); // Works for both mobile and browser

  // ✅ Open Hive box
  await LocalDatabase.initDatabase();


  // ✅ Sync if connected to internet
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult != ConnectivityResult.none) {
    await LocalDatabase.syncPendingAttendance();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Attendance',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/dashboard': (context) => DashboardPage(),
        '/attendance': (context) => AttendancePage(),
      },
    );
  }
}
