import 'package:flutter/material.dart';
import 'package:flutter_application_pro/controllers/students_service.dart';
import 'package:flutter_application_pro/models/student_model.dart';
import 'package:flutter_application_pro/add_student_page.dart';
import 'package:flutter_application_pro/edit_student_page.dart';
import 'package:flutter_application_pro/student_info_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StudentService studentService = StudentService();
  List<StudentModel> students = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken != null) {
      try {
        students = await studentService.fetchStudents(accessToken);
      } catch (e) {
        print('Failed to load students: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to load students: $e'),
        ));
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  void _deleteStudent(String id) async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('ต้องการลบข้อมูลใช่หรือไม่?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Cancel
              child: Text('ไม่ใช่'), // "No" in Thai
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirm
              child: Text('ใช่'), // "Yes" in Thai
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      if (accessToken != null) {
        try {
          await studentService.deleteStudent(id);
          _loadStudents(); // Reload the student list after deletion
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Student deleted successfully.'),
          ));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to delete student.'),
          ));
        }
      }
    }
  }

  void _navigateToDetails(StudentModel student) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StudentInfoPage(student: student)),
    );
  }

  void _logout() async {
    bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('ต้องการที่จะ Logout ใช่หรือไม่?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Cancel
              child: Text('ไม่'), // "No" in Thai
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirm
              child: Text('ใช่'), // "Yes" in Thai
            ),
          ],
        );
      },
    );

    if (confirmLogout == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Clear stored tokens or any session data
      Navigator.pushReplacementNamed(context, '/'); // Ensure '/' route is your LoginPage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // เพิ่มสีพื้นหลัง
      appBar: AppBar(
        title: Text('Student List'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : students.isEmpty
              ? Center(child: Text('No students available.', style: TextStyle(fontSize: 18, color: Colors.grey)))
              : ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return GestureDetector(
                      onTap: () => _navigateToDetails(student),
                      child: Card(
                        elevation: 5,
                        shadowColor: Colors.black38,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.blueAccent,
                                child: Text(
                                  student.std_name[0],
                                  style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                student.std_name,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text('ID: ${student.std_id}', style: TextStyle(color: Colors.grey)),
                              SizedBox(height: 10),
                              ButtonBar(
                                alignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditStudentPage(student: student),
                                        ),
                                      ).then((_) => _loadStudents());
                                    },
                                    icon: Icon(Icons.edit, color: Colors.white),
                                    label: Text('Edit'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orangeAccent,
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () => _deleteStudent(student.id),
                                    icon: Icon(Icons.delete, color: Colors.white),
                                    label: Text('Delete'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () => _navigateToDetails(student),
                                    icon: Icon(Icons.info, color: Colors.white),
                                    label: Text('Details'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.lightBlueAccent,
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddStudentPage()),
                  ).then((_) => _loadStudents());
                },
                icon: Icon(Icons.add),
                label: Text('Add Student'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _logout,
                icon: Icon(Icons.logout),
                label: Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
