import 'package:flutter/material.dart';
import 'package:ur_next_route/all_pins.dart';
import 'package:ur_next_route/role_editing.dart';

class AdminPage extends StatefulWidget{
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Admin Page",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.dehaze,
            color: Colors.white,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        backgroundColor: const Color.fromARGB(255, 4, 30, 66),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            ListTile(
              title: const Text("Role Editing"),
              trailing: TextButton( 
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RoleEditing()),
                  );
                },
                child: const Icon(Icons.keyboard_arrow_right),
              ),  
            ),

            const SizedBox(height: 25),

            ListTile(
              title: const Text("All Pins"),
              trailing: TextButton( 
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  AllPins()),
                  );
                },
                child: const Icon(Icons.keyboard_arrow_right),
              ),  
            ),
                    ],
        ),
      ),
      );
  }
}