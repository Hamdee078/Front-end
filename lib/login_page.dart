import 'package:flutter/material.dart';
import 'package:flutter_application_pro/controllers/auth_service.dart'; // Import your AuthService for admin login
import 'student/student_login_page.dart'; // Import the new student login page
import 'home_page.dart'; // Import HomePage for successful admin login

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // พื้นหลังสีขาว
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Welcome Text
            Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF004AAD),
              ),
            ),
            const SizedBox(height: 10),

            // Subtitle Text
            Text(
              'Hello there, sign in to continue!',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),

            // Username or email Field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Username or email',
                labelStyle: TextStyle(color: Colors.grey[700]),
                prefixIcon: Icon(Icons.person, color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: _emailController.text.isEmpty
                    ? null // ไม่แสดงอะไรถ้าไม่มีข้อมูล
                    : _emailController.text.contains('@')
                        ? Icon(Icons.check_circle, color: Colors.blue) // ถ้ามีข้อมูลที่ถูกต้องให้แสดงติ๊กถูก
                        : Icon(Icons.cancel, color: Colors.red), // ถ้าข้อมูลไม่ถูกต้องให้แสดงกากบาท
              ),
              onChanged: (value) {
                // Force rebuild to update the suffix icon
              },
            ),
            const SizedBox(height: 20),

            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.grey[700]),
                prefixIcon: Icon(Icons.lock, color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: _passwordController.text.isEmpty
                    ? null // ไม่แสดงอะไรถ้าไม่มีข้อมูล
                    : _passwordController.text.length >= 6 // ตรวจสอบความยาวของรหัสผ่าน
                        ? Icon(Icons.check_circle, color: Colors.blue) // ถ้ามีข้อมูลที่ถูกต้องให้แสดงติ๊กถูก
                        : Icon(Icons.cancel, color: Colors.red), // ถ้าข้อมูลไม่ถูกต้องให้แสดงกากบาท
              ),
              onChanged: (value) {
                // Force rebuild to update the suffix icon
              },
            ),
            const SizedBox(height: 30),

            // Sign in Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Validate input
                  if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter both email and password.'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  // Attempt admin login
                  try {
                    // Call AuthService to log in the admin
                    var user = await authService.login(
                      _emailController.text,
                      _passwordController.text,
                    );

                    if (user != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()), // Navigate to HomePage on success
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Admin login failed! Please try again.'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), // Full width button
                  backgroundColor: Color(0xFF004AAD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Sign in',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Student Login Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('เข้าดูสำหรับนิสิต', style: TextStyle(fontSize: 16)),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StudentLoginPage()), // Navigate to StudentLoginPage
                    );
                  },
                  child: Text('Login as Student', style: TextStyle(fontSize: 16, color: Colors.blue)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
