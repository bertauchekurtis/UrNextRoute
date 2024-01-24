import 'package:flutter/material.dart';
import '../link.dart';

class EditLinkModal extends StatefulWidget {
  Link thisLink;
  bool isInside;
  bool containsBlueLight;
  bool containsStairs;
  double brightnessLevel;
  Function delLink;
  final Function writeLinks;

  EditLinkModal({
    Key? key,
    required this.thisLink,
    required this.brightnessLevel,
    required this.isInside,
    required this.containsBlueLight,
    required this.containsStairs,
    required this.delLink,
    required this.writeLinks,
  }) : super(key: key);

  @override
  State<EditLinkModal> createState() => _EditLinkModalState();
}

class _EditLinkModalState extends State<EditLinkModal> {
  @override
  Widget build(BuildContext context) {
    //var mapEditorState = context.watch<MapEditorPage>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Edit Link",
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
              widget.thisLink.brightnessLevel = widget.brightnessLevel.toInt(),
              widget.thisLink.containsBlueLight = widget.containsBlueLight,
              widget.thisLink.containsStairs = widget.containsStairs,
              widget.thisLink.isInside = widget.isInside,
              widget.writeLinks(),
              Navigator.pop(context)
            },
            child: const Text("Save Changes"),
          ),
          ElevatedButton(
            onPressed: () => {
              widget.delLink(widget.thisLink),
              widget.writeLinks(),
              Navigator.pop(context)
            },
            child: const Text("Delete Link"),
          )
        ],
      ),
    );
  }
}
