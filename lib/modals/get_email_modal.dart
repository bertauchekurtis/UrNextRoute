import 'package:flutter/material.dart';

class GetEmailModal extends StatefulWidget {
  final Function sendEmail;
  final Function importMapData;
  final Function clearMapData;
  const GetEmailModal(
      {Key? key,
      required this.sendEmail,
      required this.importMapData,
      required this.clearMapData})
      : super(key: key);

  @override
  State<GetEmailModal> createState() => _GetEmailModalState();
}

class _GetEmailModalState extends State<GetEmailModal> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Export/Import Map Data",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 4, 30, 66),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            title: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter email address to export map to.',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => {
              widget.sendEmail(emailController.text),
              Navigator.pop(context)
            },
            child: const Text("Export Data via Email"),
          ),
          const Padding(padding: EdgeInsets.all(12.0)),
          ElevatedButton(
            onPressed: () => {
              showDialog(
                  context: context,
                  builder: (builder) {
                    return AlertDialog(
                      title: const Text("Are you sure?"),
                      content: const Text(
                          "Importing default map data via bundle will overwrite any map editor data currently in use. Export unsaved data first."),
                      actions: [
                        ElevatedButton(
                          onPressed: () => {
                            widget.importMapData(),
                            Navigator.pop(context),
                            Navigator.pop(context),
                          },
                          child: const Text("Yes, I am sure."),
                        ),
                        ElevatedButton(
                          onPressed: () => {Navigator.pop(context)},
                          child: const Text("No, Cancel."),
                        ),
                      ],
                    );
                  })
            },
            child: const Text("Import Default Map Data via Bundle"),
          ),
          const Padding(padding: EdgeInsets.all(12.0)),
          ElevatedButton(
            onPressed: () => {
              showDialog(
                  context: context,
                  builder: (builder) {
                    return AlertDialog(
                      title: const Text("Are you sure?"),
                      content: const Text(
                          "This will clear ALL nodes AND links and CANNOT be undone."),
                      actions: [
                        ElevatedButton(
                          onPressed: () => {
                            widget.clearMapData(),
                            Navigator.pop(context),
                            Navigator.pop(context),
                          },
                          child: const Text("Yes, I am sure."),
                        ),
                        ElevatedButton(
                          onPressed: () => {Navigator.pop(context)},
                          child: const Text("No, Cancel."),
                        ),
                      ],
                    );
                  })
            },
            child: const Text("Clear Map"),
          ),
        ],
      ),
    );
  }
}
