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
        children: [
          ListTile(
            leading: const Icon(
              Icons.animation_outlined,
              size: 30,
            ),
            title: const Text("Overlay Brightness Heat Map"),
            trailing: Switch(
              value: appState.showHeatMap,
              onChanged: (value) {
                appState.toggleHeatMap();
              },
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.campaign_outlined,
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
          ListTile(
            leading: const Icon(
              Icons.build,
              size: 30,
            ),
            title: const Text("Overlay Maintenance Pins on Map"),
            trailing: Switch(
              value: appState.showMaintenancePins,
              onChanged: (value) {
                appState.toggleMaintenancePins();
              },
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.personal_injury,
              size: 30,
            ),
            title: const Text("Overlay Trip/Fall Hazard Pins on Map"),
            trailing: Switch(
              value: appState.showTripFallPins,
              onChanged: (value) {
                appState.toggleTripFallPins();
              },
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.warning,
              size: 30,
            ),
            title: const Text("Overlay Safety Hazard Pins on Map"),
            trailing: Switch(
              value: appState.showSafetyHazardPins,
              onChanged: (value) {
                appState.toggleSafetyHazardPins();
              },
            ),
          ),
        ],
      ),
    );
  }
}
