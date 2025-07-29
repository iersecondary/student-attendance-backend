import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'attendance_model.dart';

class AttendanceDatabase {
  static final AttendanceDatabase instance = AttendanceDatabase._init();
  static Database? _database;

  AttendanceDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('attendance.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE attendance (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        rollNumber TEXT,
        studentName TEXT,
        semester TEXT,
        subject TEXT,
        status TEXT
      )
    ''');
  }

  Future<void> insertAttendance(AttendanceModel attendance) async {
    final db = await instance.database;
    await db.insert('attendance', attendance.toMap());
  }

  Future<List<AttendanceModel>> getUnsyncedAttendance() async {
    final db = await instance.database;
    final result = await db.query('attendance');
    return result.map((map) => AttendanceModel.fromMap(map)).toList();
  }

  Future<void> deleteAllAttendance() async {
    final db = await instance.database;
    await db.delete('attendance');
  }
}
