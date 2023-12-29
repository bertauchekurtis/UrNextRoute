import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ur_next_route/map_editor.dart';
import 'package:ur_next_route/safety_pin.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'main.dart';
import 'node.dart';

class AddNodePage extends StatefulWidget {
  final LatLng position;
  bool isInside = false;
  final addNode;
  AddNodePage({Key? key, required this.position, this.addNode})
      : super(key: key);

  @override
  State<AddNodePage> createState() => _AddNodePageState();
}

class _AddNodePageState extends State<AddNodePage> {
  @override
  Widget build(BuildContext context) {
    //var mapEditorState = context.watch<MapEditorPage>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Add Node",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 4, 30, 66),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            leading: const Icon(Icons.pin_drop_outlined),
            title: const Text("Near <<Placeholder>>"),
            subtitle: Text(
                "Lat: ${widget.position.latitude.toStringAsFixed(4)}, Long: ${widget.position.longitude.toStringAsFixed(4)}"),
          ),
          ListTile(
            leading: const Icon(
              Icons.business,
              size: 30,
            ),
            title: const Text("Is inside?"),
            trailing: Switch(
                value: widget.isInside,
                onChanged: (bool value) {
                  setState(() {
                    widget.isInside = !widget.isInside;
                  });
                }),
          ),
          ElevatedButton(
              onPressed: () => {
                    widget.addNode(Node(0, widget.position, widget.isInside)),
                    Navigator.pop(context)
                  },
              child: const Text("Add Node"))
        ],
      ),
    );
  }
}
