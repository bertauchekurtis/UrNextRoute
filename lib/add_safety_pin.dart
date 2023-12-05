import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ur_next_route/safety_pin.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class AddSafetyPinPage extends StatefulWidget {
  final LatLng position;
  var selectedOption = 1;
  DateTime now = DateTime.now();
  late String formattedDate = DateFormat('kk:mm - EEE, MMM d').format(now);
  final user = FirebaseAuth.instance.currentUser;
  late final uid = user?.uid;
  AddSafetyPinPage({Key? key, required this.position}) : super(key: key);

  @override
  State<AddSafetyPinPage> createState() => _AddSafetyPinPageState();
}

class _AddSafetyPinPageState extends State<AddSafetyPinPage> {
  
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Add Safety Pin",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Padding(padding: const EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () {
              SafetyPin newPin = SafetyPin("Placeholder Building", 
              widget.position, 
              widget.uid!, 
              widget.selectedOption, 
              descriptionController.text, 
              widget.now, 
              DateTime(2024));
              appState.addSafetyPin(newPin);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.check,
              color: Colors.white,

            ),
          ),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 4, 30, 66),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            leading: const Icon(Icons.pin_drop_outlined),
            title: const Text("Near <<Placeholder>>"),
            subtitle: Text("Lat: ${widget.position.latitude.toStringAsFixed(4)}, Long: ${widget.position.longitude.toStringAsFixed(4)}"),
            trailing: const Icon(Icons.edit),
          ),
          const Text("   Pin Type:", style: TextStyle(fontSize: 20)),

          ListTile(
            title: const Text("Maintenance"),
            leading: Radio(
              value: 1,
              groupValue: widget.selectedOption,
              onChanged: (value) {
                setState(() {
                  widget.selectedOption = value!;
                });
              }
            ),
          ),
          ListTile(
            title: const Text("Trip/Fall Hazard"),
            leading: Radio(
              value: 2,
              groupValue: widget.selectedOption,
              onChanged: (value) {
                setState(() {
                  widget.selectedOption = value!;
                });
              }
            ),
          ),
          ListTile(
            title: const Text("Safety Concern"),
            leading: Radio(
              value: 3,
              groupValue: widget.selectedOption,
              onChanged: (value) {
                setState(() {
                  widget.selectedOption = value!;
                });
              }
            ),
          ),
          ListTile(
            leading: const Icon(Icons.watch_later_outlined),
            title: Text("Time: ${widget.formattedDate}"),
            //subtitle: const Text("Tap to back date"), will do back dating later
            //trailing: const Icon(Icons.edit),
          ),
          
          const Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'When should this pin expire?',
              ),
            ),
          ),

          const SizedBox(height: 15,),

          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a short description.',
              ),
            ),
          ),

          const SizedBox(height: 15,),

          const Text("Location Preview:",
          textAlign: TextAlign.center,),
        
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 250,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: widget.position,
                initialZoom: 18,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(markers: [
                  Marker(
                    point: widget.position,
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.push_pin,
                      color: Colors.blue.shade900,
                      size: 60,
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}