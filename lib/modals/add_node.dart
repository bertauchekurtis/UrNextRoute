import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../node.dart';

class AddNodePage extends StatefulWidget {
  final LatLng position;
  bool isInside = false;
  final Function addNode;
  AddNodePage({Key? key, required this.position, required this.addNode})
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
