import 'package:flutter/material.dart';
import 'package:flutter_application_pro/controllers/students_service.dart';
import 'package:flutter_application_pro/models/student_model.dart';

class EditStudentPage extends StatefulWidget {
  final StudentModel student;

  EditStudentPage({required this.student});

  @override
  _EditStudentPageState createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _grammarController = TextEditingController();
  final TextEditingController _vocabularyController = TextEditingController();
  final TextEditingController _readingController = TextEditingController();
  final TextEditingController _listeningController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _cefrController = TextEditingController();
  final StudentService studentService = StudentService();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.student.std_name;
    _idController.text = widget.student.std_id;
    _grammarController.text = widget.student.grammar;
    _vocabularyController.text = widget.student.vocabulary;
    _readingController.text = widget.student.reading;
    _listeningController.text = widget.student.listening;
    _totalController.text = widget.student.total;
    _cefrController.text = widget.student.cefr;
  }

  void updateStudent() async {
    StudentModel updatedStudent = StudentModel(
      id: widget.student.id,
      std_id: _idController.text,
      std_name: _nameController.text,
      grammar: _grammarController.text,
      vocabulary: _vocabularyController.text,
      reading: _readingController.text,
      listening: _listeningController.text,
      total: _totalController.text,
      cefr: _cefrController.text,
    );

    try {
      await studentService.updateStudent(widget.student.id, updatedStudent);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update student: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Student'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(_nameController, 'Student Name'),
              _buildTextField(_idController, 'Student ID'),
              _buildTextField(_grammarController, 'Grammar Score'),
              _buildTextField(_vocabularyController, 'Vocabulary Score'),
              _buildTextField(_readingController, 'Reading Score'),
              _buildTextField(_listeningController, 'Listening Score'),
              _buildTextField(_totalController, 'Total Score'),
              _buildTextField(_cefrController, 'CEFR Level'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateStudent,
                child: Text('Update Student'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12), backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.blue),
          ),
          labelStyle: TextStyle(color: Colors.blueAccent),
        ),
      ),
    );
  }
}
