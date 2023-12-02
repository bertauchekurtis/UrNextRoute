import 'package:flutter/material.dart';

class AddPinModal extends StatelessWidget {
  const AddPinModal ({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.33,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 4, 30, 66),
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 10),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                ),
              tileColor: Colors.white,
              title: const Center(child: Text("Set Start Point",
              style: TextStyle(fontSize: 25),)),
              contentPadding: const EdgeInsets.all(10),
            ),
            const SizedBox(height: 10,),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                ),
              tileColor: Colors.white,
              title: const Center(child: Text("Set End Point",
              style: TextStyle(fontSize: 25),)),
              contentPadding: const EdgeInsets.all(10),
            ),
            const SizedBox(height: 10,),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                ),
              tileColor: Colors.white,
              title: const Center(child: Text("Drop Safety Pin",
              style: TextStyle(fontSize: 25),)),
              contentPadding: const EdgeInsets.all(10),
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}
