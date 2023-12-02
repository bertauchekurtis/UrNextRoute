import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Settings",
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
        children:  [
          ListTile(
            leading: const Icon(
              Icons.store,
              size: 30,
            ),
            title: const Text("Overlay Emergency Blue Lights on Map"),
            trailing: Switch(
              value: appState.showBlueLights,
              onChanged: (value) {
                appState.toggleBlueLights();
              },
            ),
          ),
        ],
      ),
    );
  }
}