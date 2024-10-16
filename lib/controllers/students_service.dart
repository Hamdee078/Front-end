// lib/controllers/students_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_pro/models/student_model.dart';
import 'package:flutter_application_pro/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentService {
  // Fetching students with access token
  Future<List<StudentModel>> fetchStudents(String accessToken) async {
    final response = await http.get(
      Uri.parse('$apiURL/api/students'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((student) => StudentModel.fromJson(student)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }

  // Fetching a single student by ID
  Future<StudentModel> fetchStudentById(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      throw Exception('Access token is missing.');
    }

    final response = await http.get(
      Uri.parse('$apiURL/api/students/$id'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return StudentModel.fromJson(jsonResponse); // Adjust based on your API response
    } else {
      throw Exception('Failed to load student data: ${response.body}');
    }
  }

  // Adding a new student with access token
  Future<void> addStudent(StudentModel student) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      throw Exception('Access token is missing.');
    }

    final response = await http.post(
      Uri.parse('$apiURL/api/students'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(student.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add student: ${response.body}');
    }
  }

  // Updating a student with access token
  Future<void> updateStudent(String id, StudentModel student) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      throw Exception('Access token is missing.');
    }

    final response = await http.put(
      Uri.parse('$apiURL/api/students/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode(student.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update student: ${response.body}');
    }
  }

  // Deleting a student with access token
  Future<void> deleteStudent(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      throw Exception('Access token is missing.');
    }

    final response = await http.delete(
      Uri.parse('$apiURL/api/students/$id'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete student: ${response.body}');
    }
  }
}
