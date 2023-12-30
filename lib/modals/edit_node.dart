import 'package:flutter/material.dart';
import '../node.dart';

class EditNodeModal extends StatefulWidget {
  Node thisNode;
  bool isInside;
  final Function delNode;
  EditNodeModal(
      {Key? key,
      required this.thisNode,
      required this.isInside,
      required this.delNode})
      : super(key: key);

  @override
  State<EditNodeModal> createState() => _EditNodeModalState();
}

class _EditNodeModalState extends State<EditNodeModal> {
  @override
  Widget build(BuildContext context) {
    //var mapEditorState = context.watch<MapEditorPage>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Edit Node",
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
                "Lat: ${widget.thisNode.position.latitude.toStringAsFixed(4)}, Long: ${widget.thisNode.position.longitude.toStringAsFixed(4)}"),
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
                    widget.thisNode.isInside = widget.isInside,
                    Navigator.pop(context)
                  },
              child: const Text("Save Changes")),
          ElevatedButton(
              onPressed: () =>
                  {widget.delNode(widget.thisNode), Navigator.pop(context)},
              child: const Text("Delete Node"))
        ],
      ),
    );
  }
}
