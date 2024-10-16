import 'package:flutter/material.dart';
import 'package:flutter_application_pro/models/student_model.dart';

class StudentInfoPage extends StatelessWidget {
  final StudentModel student;

  StudentInfoPage({required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(student.std_name),
      ),
      body: SingleChildScrollView( // Make the body scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Center(
              child: CircleAvatar(
                radius: 50, // Size of the avatar
                child: Text(
                  student.std_name[0], // Display first letter of the student's name
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Student ID
            _buildInfoCard('Student ID', student.std_id),
            SizedBox(height: 20),
            // Academic Information
            Text(
              'Academic Information',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildInfoCard('Grammar', student.grammar),
            _buildInfoCard('Vocabulary', student.vocabulary),
            _buildInfoCard('Reading', student.reading),
            _buildInfoCard('Listening', student.listening),
            _buildInfoCard('Total', student.total),
            _buildInfoCard('CEFR Level', student.cefr),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
