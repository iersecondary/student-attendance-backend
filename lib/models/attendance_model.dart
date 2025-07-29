class AttendanceModel {
  final String rollNumber;
  final String studentName;
  final String semester;
  final String subject;
  final String status;

  AttendanceModel({
    required this.rollNumber,
    required this.studentName,
    required this.semester,
    required this.subject,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'rollNumber': rollNumber,
      'studentName': studentName,
      'semester': semester,
      'subject': subject,
      'status': status,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      rollNumber: map['rollNumber'],
      studentName: map['studentName'],
      semester: map['semester'],
      subject: map['subject'],
      status: map['status'],
    );
  }
}
