import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ur_next_route/main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  // Future<void> saveSettings(MyAppState appState) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   prefs.getBool('ShowBlueLights') ?? false;
  //   prefs.getBool('ShowMaintenancePins') ?? false;
  //   prefs.getBool('TripFallHazardPins') ?? false;
  //   prefs.getBool('SafetyHazardPins') ?? false;

  //   prefs.setBool('ShowBlueLights', appState.showBlueLights);
  //   prefs.setBool('ShowMaintenancePins', appState.showMaintenancePins);
  //   prefs.setBool('TripFallHazardPins', appState.showTripFallPins);
  //   prefs.setBool('SafetyHazardPins', appState.showSafetyHazardPins);
  // }

  // Future<void> setSettings(bool setting, String settingName) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool(settingName, setting);
  // }

  // Future<bool> getSettings(String settingName) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool settingStatus = await prefs.getBool(settingName) ?? false;

  //   return settingStatus;
  // }

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
                Icons.campaign_outlined,
                size: 30,
              ),
              title: const Text("Overlay Emergency Blue Lights on Map"),
              trailing: FutureBuilder<bool>(
                  future: appState.showBlueLights,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      return Switch(
                          value: snapshot.data ?? false,
                          onChanged: (value) {
                            appState.toggleBlueLights();
                          });
                    }
                  })
              // trailing: Switch(
              //   value: appState.showBlueLights,
              //   onChanged: (value) async {
              //     await appState.toggleBlueLights();
              //     // saveSettings(appState); // Save settings when switch changes
              //     // setSettings(appState.showBlueLights, "ShowBlueLights");
              //   },
              // ),
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
                // saveSettings(appState); // Save settings when switch changes
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
                // saveSettings(appState); // Save settings when switch changes
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
                // saveSettings(appState); // Save settings when switch changes
              },
            ),
          ),
        ],
      ),
    );
  }
}

// class MyAppState with ChangeNotifier {
//   bool _showBlueLights = false;
//   bool _showMaintenancePins = false;
//   bool _showTripFallPins = false;
//   bool _showSafetyHazardPins = false;

//   bool get showBlueLights => _showBlueLights;
//   bool get showMaintenancePins => _showMaintenancePins;
//   bool get showTripFallPins => _showTripFallPins;
//   bool get showSafetyHazardPins => _showSafetyHazardPins;

//   void toggleBlueLights() {
//     _showBlueLights = !_showBlueLights;
//     notifyListeners();
//   }

//   void toggleMaintenancePins() {
//     _showMaintenancePins = !_showMaintenancePins;
//     notifyListeners();
//   }

//   void toggleTripFallPins() {
//     _showTripFallPins = !_showTripFallPins;
//     notifyListeners();
//   }

//   void toggleSafetyHazardPins() {
//     _showSafetyHazardPins = !_showSafetyHazardPins;
//     notifyListeners();
//   }

// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'main.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SettingsPage extends StatelessWidget {
//   const SettingsPage({super.key});

//   Future<void> saveSettings() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     prefs.setBool('ShowBlueLights', false);
//     prefs.setBool('ShowMaintenancePins', false);
//     prefs.setBool('TripFallHazardPins', false);
//     prefs.setBool('SafetyHazardPins', false);

//     // String hazardPinsSetting = prefs.getBool('HazardPins');
//     // print('Hazard Pin Setting: $hazardPinsSetting');
//   }

//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text(
//           "Settings",
//           style: TextStyle(color: Colors.white),
//         ),
//         leading: IconButton(
//           icon: const Icon(
//             Icons.dehaze,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             Scaffold.of(context).openDrawer();
//           },
//         ),
//         backgroundColor: const Color.fromARGB(255, 4, 30, 66),
//       ),
//       body: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           ListTile(
//             leading: const Icon(
//               Icons.campaign_outlined,
//               size: 30,
//             ),
//             title: const Text("Overlay Emergency Blue Lights on Map"),
//             trailing: Switch(
//               value: appState.showBlueLights,
//               onChanged: (value) {
//                 appState.toggleBlueLights();
//               },
//             ),
//           ),
//           ListTile(
//             leading: const Icon(
//               Icons.build,
//               size: 30,
//             ),
//             title: const Text("Overlay Maintenance Pins on Map"),
//             trailing: Switch(
//               value: appState.showMaintenancePins,
//               onChanged: (value) {
//                 appState.toggleMaintenancePins();
//               },
//             ),
//           ),
//           ListTile(
//             leading: const Icon(
//               Icons.personal_injury,
//               size: 30,
//             ),
//             title: const Text("Overlay Trip/Fall Hazard Pins on Map"),
//             trailing: Switch(
//               value: appState.showTripFallPins,
//               onChanged: (value) {
//                 appState.toggleTripFallPins();
//               },
//             ),
//           ),
//           ListTile(
//             leading: const Icon(
//               Icons.warning,
//               size: 30,
//             ),
//             title: const Text("Overlay Safety Hazard Pins on Map"),
//             trailing: Switch(
//               value: appState.showSafetyHazardPins,
//               //prefs.setBool('HazardPins', false);
//               onChanged: (value) {
//                 appState.toggleSafetyHazardPins();
//                 //prefs.setBool('key', true);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Future<void> demoSharedPreferences() async {
//   //   // Get instance of SharedPreferences
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();

//   //   // Store a value
//   //   prefs.setString('username', 'JohnDoe');

//   //   prefs.setString('HazardPins', 'ON');

//   //   // Retrieve a stored value
//   //   String username = prefs.getString('username') ?? 'Guest';
//   //   print('Username: $username');

//   //   String hazardPinsSetting =
//   //       prefs.getString('HazardPins') ?? 'HazardPinSetting';
//   //   print('Hazard Pin Setting: $hazardPinsSetting');
//   // }
// }
