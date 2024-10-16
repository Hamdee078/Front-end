import 'package:flutter/material.dart';
import 'package:flutter_application_pro/controllers/auth_service.dart';
import 'package:flutter_application_pro/models/student_model.dart';
import 'package:flutter_application_pro/student/home_page_std.dart';

class StudentLoginPage extends StatefulWidget {
  @override
  _StudentLoginPageState createState() => _StudentLoginPageState();
}

class _StudentLoginPageState extends State<StudentLoginPage> {
  final AuthService authService = AuthService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  bool isNameValid = false; // Track if the name is valid
  bool isIdValid = false; // Track if the ID is valid

  void _login() async {
    if (nameController.text.isEmpty || idController.text.isEmpty) {
      _showError("Please enter both name and student ID.");
      return;
    }

    try {
      StudentModel? student = await authService.studentLogin(nameController.text, idController.text);
      if (student != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StudentHomePage(user: student)),
        );
      } else {
        _showError("Login failed! Please try again.");
      }
    } catch (e) {
      _showError("Error: $e");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Login'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // ย้อนกลับไปหน้าก่อนหน้า
          },
        ),
      ),
      backgroundColor: Colors.white, // Background color
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Welcome Text
            Text(
              'Student Login',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF004AAD),
              ),
            ),
            const SizedBox(height: 10),

            // Subtitle Text
            Text(
              'Please enter your details to login.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),

            // Student Name Field
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Student Name',
                labelStyle: TextStyle(color: Colors.grey[700]),
                prefixIcon: Icon(Icons.person, color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: nameController.text.isEmpty
                    ? null
                    : isNameValid
                        ? Icon(Icons.check_circle, color: Colors.blue)
                        : Icon(Icons.cancel, color: Colors.red),
              ),
              onChanged: (value) {
                setState(() {
                  isNameValid = value.isNotEmpty; // Validate if name is not empty
                });
              },
            ),
            SizedBox(height: 20),

            // Student ID Field
            TextField(
              controller: idController,
              decoration: InputDecoration(
                labelText: 'Student ID',
                labelStyle: TextStyle(color: Colors.grey[700]),
                prefixIcon: Icon(Icons.card_membership, color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: idController.text.isEmpty
                    ? null
                    : isIdValid
                        ? Icon(Icons.check_circle, color: Colors.blue)
                        : Icon(Icons.cancel, color: Colors.red),
              ),
              keyboardType: TextInputType.number, // Ensure correct keyboard type
              onChanged: (value) {
                setState(() {
                  isIdValid = value.isNotEmpty; // Validate if ID is not empty
                });
              },
            ),
            SizedBox(height: 20),

            // Login Button
            Center(
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), // Full width button
                  backgroundColor: Color(0xFF004AAD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
