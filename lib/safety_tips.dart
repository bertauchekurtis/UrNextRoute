import 'package:flutter/material.dart';

class SafetyTips extends StatelessWidget {
  SafetyTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Safety Tips",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
           Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 4, 30, 66),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: const [
          ListTile(
            leading: Icon(Icons.pin_drop_outlined),
            title: Text("Be aware of your surroundings"),
          ),
          ListTile(
//            leading: Icon(Icons.pin_drop_outlined),
            title: Text("Walk in the center of the sidewalk, away from building doorways, hedges, and parked cars"),
          ), 
          ListTile(
//            leading: Icon(Icons.pin_drop_outlined),
            title: Text("Try to avoid walking alone at night"),
          ),
          ListTile(
//            leading: Icon(Icons.pin_drop_outlined),
            title: Text("Avoid walking down dark, vacant, or deserted"),
          ),
          ListTile(
//            leading: Icon(Icons.pin_drop_outlined),
            title: Text("Always look where you are going, do not get distracted with your phone"),
          ),
          ListTile(
//            leading: Icon(Icons.pin_drop_outlined),
            title: Text("Tuck gold chains and other jewelry that might attract a criminal's attention inside your clothing"),
          ),
          ListTile(
//            leading: Icon(Icons.pin_drop_outlined),
            title: Text("Tuck gold chains and other jewelry that might attract a criminal's attention inside your clothing"),
          ),      
        ],
      ),
    );
  }
}