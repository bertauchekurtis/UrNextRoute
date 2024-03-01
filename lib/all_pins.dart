import 'package:flutter/material.dart';

class AllPins extends StatefulWidget{
  const AllPins({super.key});

  @override
  State<AllPins> createState() => _AllPinsState();
}

class _AllPinsState extends State<AllPins> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "All Pins Page",
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