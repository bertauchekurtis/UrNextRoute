import 'package:flutter/material.dart';

class RouteSettingsPage extends StatefulWidget {
  RouteSettingsPage({super.key});

  @override
  State<RouteSettingsPage> createState() => _RouteSettingsPageState();
}

class _RouteSettingsPageState extends State<RouteSettingsPage> {
  double _blueLightValue = 0.9;
  double _brightnessPref = 0.5;
  bool allowStairs = true;
  bool allowBuildings = true;
  bool allowPins = true;
  @override
  Widget build(BuildContext context) {
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
              value: _brightnessPref,
              onChanged: (value) {
                setState(() {
                  _brightnessPref = value;
                });
              },
            ),
            subtitle: const Text(
              "Path Brightness Preference",
              textAlign: TextAlign.center,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.light_sharp,
              size: 30,
              color: Colors.blue,
            ),
            title: Slider(
              value: _blueLightValue,
              divisions: 100,
              min: 0,
              max: 1,
              onChanged: (value) {
                setState(() {
                  _blueLightValue = value;
                });
              },
            ),
            subtitle: const Text(
              "Emergency Blue Light Closeness",
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(
            color: Color.fromARGB(255, 4, 30, 66),
          ),
          ListTile(
            leading: const Icon(
              Icons.stairs,
              size: 30,
            ),
            title: const Text("Allow routing with Stairs"),
            trailing: Switch(
              value: allowStairs,
              onChanged: (bool value) {
              setState(() {
                allowStairs = value;
              });}
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.store,
              size: 30,
            ),
            title: const Text("Allow routing through buildings"),
            trailing: Switch(
              value: allowBuildings,
              onChanged: (value) {
                setState(() {
                  allowBuildings = value;
                });
              },
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.pin_drop,
              size: 30,
            ),
            title: const Text("Allow routing near safety pins"),
            trailing: Switch(
              value: allowPins,
              onChanged: (value) {
                setState(() {
                  allowPins = value;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
