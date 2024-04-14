import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../node.dart';
import '../link.dart';

class AddLinkModal extends StatefulWidget {
  final Node startNode;
  final Node endNode;
  final Function addLink;
  final Function getNewLinkuuid;

  double brightnessLevel = 0;
  bool isInside = false;
  bool containsBlueLight = false;
  bool containsStairs = false;

  AddLinkModal(
      {Key? key,
      required this.startNode,
      required this.endNode,
      required this.addLink,
      required this.getNewLinkuuid})
      : super(key: key);

  @override
  State<AddLinkModal> createState() => _AddLinkModalState();
}

class _AddLinkModalState extends State<AddLinkModal> {
  final TextEditingController brightnessController = TextEditingController();
  Distance distance =
      const Distance(roundResult: false, calculator: Vincenty());
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
            title: TextField(
              controller: brightnessController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter link brightness in Lux',
              ),
            ),
            subtitle: const Text(
              "Brightness",
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
              onPressed: ()  {
                try {
                  double test = double.parse(brightnessController.text);
                  widget.addLink(Link(
                        widget.getNewLinkuuid(),
                        widget.startNode.nodeId,
                        widget.endNode.nodeId,
                        double.parse(brightnessController.text),
                        widget.startNode.position,
                        widget.endNode.position,
                        widget.isInside,
                        widget.containsBlueLight,
                        widget.containsStairs,
                        distance.as(LengthUnit.Meter, widget.startNode.position,
                            widget.endNode.position)));
                    Navigator.pop(context);
                } on Exception {
                  showDialog(
                    context: context, 
                    builder: (builder){
                      return AlertDialog(
                        title: const Text("Error"),
                        content: const Text("Inputted data is not a number. Please fix and try again."),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            }, 
                            child: const Text("Close Alert"))
                        ],
                      );
                    });
                }
              },
              child: const Text("Add Link"))
        ],
      ),
    );
  }
}
