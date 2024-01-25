import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../node.dart';

class GetEmailModal extends StatefulWidget {
  final Function sendEmail;
  GetEmailModal({Key? key, required this.sendEmail}) : super(key: key);

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
          "Export Map Data as CSV",
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
              child: const Text("Export Data via Email"))
        ],
      ),
    );
  }
}
