import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:ur_next_route/main.dart';
import 'package:ur_next_route/safety_pin.dart';
import 'package:intl/intl.dart';
import 'main.dart';

class EditPinPage extends StatelessWidget {
  const EditPinPage({Key? key, required this.clickPin}) : super(key: key);
  final SafetyPin clickPin;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Edit Pin",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          Padding(padding: const EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: (){
              showDialog(
                context: context, 
                builder: (context){
                  return AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text('Are you sure you want to delete this pin?'),
                    actions: [
                      ElevatedButton(onPressed: () => {
                        appState.removePins(clickPin),
                        Navigator.pop(context),
                        Navigator.pop(context),
                      },
                      child: const Text('Confirm'),
                      ),
                      ElevatedButton(onPressed: () => {
                        Navigator.pop(context),
                      }, 
                      child: const Text('Decline'))
                    ],
                  );
                }
                );
//              appState.removePins(clickPin);
 //             Navigator.pop(context);
            },
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
        ],
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
        children: [
          ListTile(
            leading: const Icon(Icons.pin_drop_outlined),
            title: Text("Near ${clickPin.closestBuilding}"),
            subtitle: const Text("Location"),
            trailing: const Icon(Icons.edit),
          ),
          ListTile(
            leading: const Icon(Icons.watch_later_outlined),
            title: Text(DateFormat('kk:mm - EEE, MMM d')
                .format(clickPin.expirationTime)),
            subtitle: const Text("Expiration time"),
            trailing: const Icon(Icons.edit),
          ),
          if (clickPin.type == 1)
            const ListTile(
              leading: Icon(Icons.build),
              title: Text("Maintenance"),
              subtitle: Text("Pin Type"),
              trailing: Icon(Icons.edit),
            ),
          if (clickPin.type == 2)
            const ListTile(
              leading: Icon(Icons.personal_injury),
              title: Text("Trip/Fall Hazard"),
              subtitle: Text("Pin Type"),
              trailing: Icon(Icons.edit),
            ),
          if (clickPin.type == 3)
            const ListTile(
              leading: Icon(Icons.warning),
              title: Text("Safety Concern "),
              subtitle: Text("Pin Type"),
              trailing: Icon(Icons.edit),
            ),
          ListTile(
            leading: const Icon(Icons.description),
            title: Text(clickPin.description),
            subtitle: const Text("Description"),
            trailing: const Icon(Icons.edit),
          ),
          const Text(
            "Tap on a property to edit",
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 420,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: clickPin.position,
                initialZoom: 18,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(markers: [
                  Marker(
                    point: clickPin.position,
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
