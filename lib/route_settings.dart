import 'package:flutter/material.dart';

class RouteSettingsPage extends StatelessWidget {
  const RouteSettingsPage({super.key});

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
              value: 0.2,
              onChanged: (value) {},
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
              value: 0.3,
              onChanged: (value) {},
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
              value: true,
              onChanged: (bool value) {},
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.store,
              size: 30,
            ),
            title: const Text("Allow routing through buildings"),
            trailing: Switch(
              value: false,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.pin_drop,
              size: 30,
            ),
            title: const Text("Allow routing near maintenance pins"),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          )
        ],
      ),
    );
  }
}
