import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_pro/models/user_model.dart';
import 'package:flutter_application_pro/variables.dart'; // นำเข้าตัวแปร apiURL
import 'package:shared_preferences/shared_preferences.dart'; // เพิ่มการนำเข้า SharedPreferences
import 'package:flutter_application_pro/models/student_model.dart';

class AuthService {
  // Login method
  Future<UserModel?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$apiURL/api/auth/login"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // บันทึก accessToken และ refreshToken ลงใน SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', data['accessToken']);
        await prefs.setString('refreshToken', data['refreshToken']);
        
        // บันทึกข้อมูลผู้ใช้ (ถ้าจำเป็น)
        await prefs.setString('username', username); // หรือบันทึกข้อมูลอื่น ๆ ตามที่ต้องการ

        return UserModel.fromJson(data);
      } else {
        throw Exception('Failed to login. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred during login: $e');
    }
  }
// Updated student login method in AuthService
Future<StudentModel?> studentLogin(String name, String studentId) async {
    try {
      final response = await http.post(
        Uri.parse('$apiURL/api/auth/student/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'std_name': name,
          'std_id': studentId,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('studentId', data['student']['std_id']);
        await prefs.setString('studentName', data['student']['std_name']);
        await prefs.setString('accessToken', data['accessToken']);

        return StudentModel.fromJson(data['student']);
      } else {
        throw Exception('Failed to login as student. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred during student login: $e');
    }
  }

  // Refresh token method
  Future<String?> refreshToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse("$apiURL/api/auth/refresh"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'refreshToken': refreshToken,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['accessToken']; // สมมติว่าคุณได้ access token ใหม่จากการรีเฟรช
      } else {
        throw Exception('Failed to refresh token. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred during token refresh: $e');
    }
  }
}
