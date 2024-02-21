import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class CampusVictimAdvocate extends StatelessWidget {
  const CampusVictimAdvocate({super.key});

  final advocate = '7752217634';
  final assistant = '7753283210';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Campus Victim Advocate",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            // Scaffold.of(context).openDrawer();
            Navigator.pop(context);
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
              title: const Text("Campus Victim Advocate"),
              trailing: TextButton(
                onPressed: () {
                  FlutterPhoneDirectCaller.callNumber(advocate);
                },
                child: const Icon(
                  Icons.local_phone_rounded,
                ),
              ),
            ),
            const SizedBox(height: 25),
            ListTile(
              title: const Text("Victim Witness Associate Center"),
              trailing: TextButton(
                onPressed: () {
                  FlutterPhoneDirectCaller.callNumber(assistant);
                },
                child: const Icon(
                  Icons.local_phone_rounded,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
