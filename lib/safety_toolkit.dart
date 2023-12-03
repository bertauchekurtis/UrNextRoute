import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:volume_controller/volume_controller.dart';
import 'campus_victim_advocate.dart';

class SafetyToolKit extends StatelessWidget {
  SafetyToolKit({super.key});
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Safety Toolkit",
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 30),
                padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),  
                side: const BorderSide(color: Color.fromARGB(255, 0, 12, 146), width: 1.5)
              ),
              child: const Text("Safety Tips", textAlign: TextAlign.center),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 30),
                padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),  
                side: const BorderSide(color: Color.fromARGB(255, 0, 12, 146), width: 1.5)
              ),
              child: const Text("Title IX Resources",  textAlign: TextAlign.center),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 30),
                padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),  
                side: const BorderSide(color: Color.fromARGB(255, 0, 12, 146), width: 1.5)
              ),
              child: const Text("Non-Emergency Police",  textAlign: TextAlign.center),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 30),
                padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),  
                side: const BorderSide(color: Color.fromARGB(255, 0, 12, 146), width: 1.5)
              ),
              child: const Text("Report a Tip",  textAlign: TextAlign.center),
            ),

            const SizedBox(height: 25),            
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 30),
                padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),  
                side: const BorderSide(color: Color.fromARGB(255, 0, 12, 146), width: 1.5)
              ),
              onPressed: () {
                const CampusVictimAdvocate();
              },
              child: const Text("Campus Victim Advocate",  textAlign: TextAlign.center),
            ),

            const SizedBox(height: 25),  

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 30),
                padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),  
                side: const BorderSide(color: Color.fromARGB(255, 0, 12, 146), width: 1.5)
              ),
              onPressed: () {
                VolumeController().maxVolume();
                player.play(AssetSource('alarm.mp3'));
              },
              child: const Text("Loud Alarm",  textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
