import 'package:flutter/material.dart';

class RoleEditing extends StatefulWidget{
  const RoleEditing({super.key});

  @override
  State<RoleEditing> createState() => _RoleEditingState();
}

class _RoleEditingState extends State<RoleEditing> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Role Editing Page",
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
      );
    }
}