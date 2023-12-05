import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'safety_tips.dart';
import 'campus_victim_advocate.dart';

class SafetyToolKit extends StatefulWidget {
  const SafetyToolKit({super.key});

  @override
  State<SafetyToolKit> createState() => _SafetyToolKitState();
}

class _SafetyToolKitState extends State<SafetyToolKit> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final player = AudioPlayer();
  final Uri _url = Uri.parse('https://www.unr.edu/equal-opportunity-title-ix/resources');
  PlayerState _playerState = PlayerState.stopped; 

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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            ListTile(
              title: const Text("Safety Tips"),
              trailing: TextButton( 
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SafetyTips()),
                  );
                },
                child: const Icon(Icons.keyboard_arrow_right),
              ),  
            ),

            const SizedBox(height: 25),

            ListTile(
              title: const Text("Title IX Resources"),
              trailing: TextButton( 
                onPressed: () {
                    _launchUrl();
                },
                child: const Icon(Icons.keyboard_arrow_right),
              ),  
            ),

            const SizedBox(height: 25),

            ListTile(
              title: const Text("Campus Police"),
              trailing: TextButton( 
                onPressed: () {
                  FlutterPhoneDirectCaller.callNumber('7753342677');
                },
                child: const Icon(Icons.local_phone_rounded),
              ),  
            ),

            const SizedBox(height: 25),            
            
          ListTile(
            title: const Text("Campus Victum Advocate"),
            trailing: TextButton(  
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CampusVictimAdvocate()),
                );
              },
          child: const Icon(Icons.keyboard_arrow_right),
          )
            ),

            const SizedBox(height: 25),  

            ListTile(
              title: const Text("Loud Alarm"),
              trailing: TextButton( 
                onPressed: () {
                if(_playerState == PlayerState.stopped){
                  VolumeController().maxVolume();
                  player.play(AssetSource('alarm.mp3'));
                  setState(() {
                    _playerState = PlayerState.playing; 
                  });
                }
                else{
                  player.stop();
                  setState(() {
                    _playerState = PlayerState.stopped;
                  });
                }
              },
                child: const Icon(Icons.notifications_active),
              ),  
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _launchUrl () async {
   if (!await launchUrl(_url)) {
        throw Exception('Could not launch $_url');
    }
  }
}
