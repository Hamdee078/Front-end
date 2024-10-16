import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_application_pro/models/student_model.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ใช้ในการจัดการการล็อกเอาท์

class StudentHomePage extends StatefulWidget {
  final StudentModel user;

  StudentHomePage({required this.user});

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Page'),
        backgroundColor: Color(0xFF004AAD),
        automaticallyImplyLeading: false, // ลบปุ่มย้อนกลับตรงมุมบนซ้าย
        actions: [
          IconButton(
            icon: Icon(Icons.logout), // ปุ่มล็อกเอาท์
            onPressed: () async {
              await _showLogoutDialog(); // แสดงกล่องข้อความยืนยันการล็อกเอาท์
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          _buildExamResultsTab(),
          _buildProfileTab(),
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react,
        backgroundColor: const Color.fromARGB(255, 41, 88, 255),
        activeColor: Colors.white,
        color: Colors.white,
        items: const [
          TabItem(icon: Icons.assessment, title: 'ผลการสอบ'),
          TabItem(icon: Icons.person, title: 'โปรไฟล์'),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: (int i) {
          setState(() {
            _selectedIndex = i;
          });
        },
      ),
    );
  }

  // ฟังก์ชันล็อกเอาท์
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // ลบข้อมูลการล็อกอินทั้งหมด
  }

  // ฟังก์ชันแสดงกล่องข้อความยืนยันการล็อกเอาท์
  Future<void> _showLogoutDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ยืนยันการออกจากระบบ'),
        content: Text('คุณต้องการออกจากระบบหรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // ไม่ออกจากระบบ
            child: Text('ไม่'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // ออกจากระบบ
            },
            child: Text('ใช่'),
          ),
        ],
      ),
    );

    // ถ้าผู้ใช้ตอบว่าใช่ ก็ให้ทำการล็อกเอาท์
    if (result == true) {
      await _logout(); // ฟังก์ชันล็อกเอาท์
      Navigator.of(context).pushReplacementNamed('/'); // นำทางกลับไปหน้าล็อกอิน
    }
  }

  Widget _buildExamResultsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ผลการสอบของ ${widget.user.std_name}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildInfoCard('Grammar', widget.user.grammar),
          _buildInfoCard('Vocabulary', widget.user.vocabulary),
          _buildInfoCard('Reading', widget.user.reading),
          _buildInfoCard('Listening', widget.user.listening),
          _buildInfoCard('Total', widget.user.total),
          _buildInfoCard('CEFR Level', widget.user.cefr),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade200, Colors.blue.shade800],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/user.png'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${widget.user.std_name}',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004AAD),
                  ),
            ),
            const SizedBox(height: 8),
            Divider(
              thickness: 2,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            _buildInfoCard('Student ID', widget.user.std_id),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _showLogoutDialog(); // แสดงกล่องข้อความยืนยันการล็อกเอาท์
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 237, 39, 39), // สีพื้นหลัง
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'ออกจากระบบ',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
