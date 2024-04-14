import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class RouteSettingsPage extends StatefulWidget {
  const RouteSettingsPage({super.key});

  @override
  State<RouteSettingsPage> createState() => _RouteSettingsPageState();
}

class _RouteSettingsPageState extends State<RouteSettingsPage> {
  double _blueLightValue = 0.9;
  double _brightnessPref = 0.0;
  bool allowStairs = true;
  bool allowBuildings = true;
  bool allowPins = true;
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Route Settings",
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
              Icons.light_mode_outlined,
              size: 30,
            ),
            title: Slider(
              value: appState.pathSensitivity,
              min: 0,
              max: 9,
              onChanged: (value) {
                setState(() {
                  _brightnessPref = value;
                  appState.pathSensitivity = value;
                });
              },
              label: "Label",
            ),
            subtitle: const Text(
              "Path Brightness Preference",
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(),
          const ListTile(
            title: const Text("Set the Path Brightness Preference all the way to the left to only use distance in the calculation."),
            leading: const Icon(Icons.info_sharp),
          ),
          const ListTile(
            title: const Text("Set the Path Brightness Calculation all the way to the right to use the maximum amount of brightness scaling."),
            leading: const Icon(Icons.info_sharp),
          ),
        ],
      ),
    );
  }
}
