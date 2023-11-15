import 'package:flutter/material.dart';

class MyPinsPage extends StatelessWidget {
  const MyPinsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "My Pins",
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
      body: ListView(
        padding: EdgeInsets.zero,
        children: const [
          ListTile(
            leading: Icon(Icons.pin_drop_outlined),
            title: Text("Pin Near WPEB Engineering"),
            subtitle: Text("Expires in 2 hours 12 minutes"),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            leading: Icon(Icons.pin_drop_outlined),
            title: Text("Pin Near PSAC"),
            subtitle: Text("Expires in 2 hours 32 minutes"),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            leading: Icon(Icons.pin_drop_outlined),
            title: Text("Pin Near Raggio Building"),
            subtitle: Text("Expires in 4 hours 36 minutes"),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            leading: Icon(Icons.pin_drop_outlined),
            title: Text("Pin Near Gateway Parking Garage"),
            subtitle: Text("Expires in 2 days"),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          Text(
            "Tap on a pin to edit",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
