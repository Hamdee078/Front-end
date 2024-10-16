import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('หน้าหลัก'),
            onTap: () {
              // ทำการนำทางไปยังหน้าแรก
            },
          ),
          ExpansionTile(
            leading: Icon(Icons.login),
            title: Text("LOG IN"),
            children: [
              ListTile(
                title: Text("นิสิต/STUDENT"),
                onTap: () {
                  // นำทางไปยังหน้าล็อกอินของนิสิต
                },
              ),
              ListTile(
                title: Text("บุคลากร/STAFF"),
                onTap: () {
                  // นำทางไปยังหน้าล็อกอินของบุคลากร
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
