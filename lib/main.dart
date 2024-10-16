import 'package:flutter/material.dart';
import 'login_page.dart'; // นำเข้าหน้า Login


void main() {
  runApp(MyApp()); // ฟังก์ชัน main() สำหรับเริ่มแอป
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // ซ่อนแบนเนอร์ Debug
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Define the initial route
      routes: {
        '/': (context) => LoginPage(), // หน้าเริ่มต้นเป็นหน้า Login
      },
    );
  }
}
