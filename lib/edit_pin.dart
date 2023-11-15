import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class EditPinPage extends StatelessWidget {
  const EditPinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Edit Pin",
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
        children: [
          const ListTile(
            leading: Icon(Icons.pin_drop_outlined),
            title: Text("Near WPEB Engineering"),
            subtitle: Text("Location"),
            trailing: Icon(Icons.edit),
          ),
          const ListTile(
            leading: Icon(Icons.watch_later_outlined),
            title: Text("Expires in 2 hours 32 minutes"),
            subtitle: Text("Expiration time"),
            trailing: Icon(Icons.edit),
          ),
          const ListTile(
            leading: Icon(Icons.build),
            title: Text("Maintenance Pin"),
            subtitle: Text("Pin Type"),
            trailing: Icon(Icons.edit),
          ),
          const ListTile(
            leading: Icon(Icons.description),
            title: Text("Loose Handrailing"),
            subtitle: Text("Description"),
            trailing: Icon(Icons.edit),
          ),
          const Text(
            "Tap on a property to edit",
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 420,
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(39.539961, -119.812230),
                initialZoom: 18,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(markers: [
                  Marker(
                    point: const LatLng(39.539961, -119.812230),
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
