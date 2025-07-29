import 'package:flutter/material.dart';
import '../database/local_db.dart'; // 👈 Add this import

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    LocalDatabase.syncPendingAttendance(); // 👈 Sync on open
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to the Dashboard!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/attendance');
              },
              child: const Text('Go to Attendance Page'),
            ),
          ],
        ),
      ),
    );
  }
}
