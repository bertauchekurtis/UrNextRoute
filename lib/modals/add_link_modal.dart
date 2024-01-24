import 'package:flutter/material.dart';
import '../node.dart';
import '../link.dart';

class AddLinkModal extends StatefulWidget {
  final Node startNode;
  final Node endNode;
  final Function addLink;
  final int idForNewLink;

  double brightnessLevel = 0;
  bool isInside = false;
  bool containsBlueLight = false;
  bool containsStairs = false;

  AddLinkModal(
      {Key? key,
      required this.startNode,
      required this.endNode,
      required this.addLink,
      required this.idForNewLink})
      : super(key: key);

  @override
  State<AddLinkModal> createState() => _AddLinkModalState();
}

class _AddLinkModalState extends State<AddLinkModal> {
  @override
  Widget build(BuildContext context) {
    //var mapEditorState = context.watch<MapEditorPage>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Add Link",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 4, 30, 66),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
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
          ListTile(
            leading: const Icon(
              Icons.light,
              size: 30,
            ),
            title: const Text("Is there a blue light along link?"),
            trailing: Switch(
                value: widget.containsBlueLight,
                onChanged: (bool value) {
                  setState(() {
                    widget.containsBlueLight = !widget.containsBlueLight;
                  });
                }),
          ),
          ListTile(
            leading: const Icon(
              Icons.stairs,
              size: 30,
            ),
            title: const Text("Are there stairs along link?"),
            trailing: Switch(
                value: widget.containsStairs,
                onChanged: (bool value) {
                  setState(() {
                    widget.containsStairs = !widget.containsStairs;
                  });
                }),
          ),
          ListTile(
            leading: Text(
              widget.brightnessLevel.toString(),
            ),
            title: Slider(
              value: widget.brightnessLevel,
              divisions: 10,
              min: 0,
              max: 10,
              onChanged: (value) {
                setState(() {
                  widget.brightnessLevel = value;
                });
              },
            ),
            subtitle: const Text(
              "Brightness",
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
              onPressed: () => {
                    widget.addLink(Link(
                        widget.idForNewLink,
                        widget.startNode.nodeId,
                        widget.endNode.nodeId,
                        widget.brightnessLevel.toInt(),
                        widget.startNode.position,
                        widget.endNode.position,
                        widget.isInside,
                        widget.containsBlueLight,
                        widget.containsStairs,
                        0)),
                    Navigator.pop(context)
                  },
              child: const Text("Add Link"))
        ],
      ),
    );
  }
}
