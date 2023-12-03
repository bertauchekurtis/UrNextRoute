import 'package:flutter/material.dart';

class CampusVictimAdvocate extends StatelessWidget {
  const CampusVictimAdvocate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Campus Victim Advocate",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}