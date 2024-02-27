import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'package:intl/intl.dart';
import 'edit_pin.dart';

class MyPinsPage extends StatelessWidget {
  const MyPinsPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var allPins = appState.maintenancePinsList +
        appState.tripFallPinsList +
        appState.safetyHazardPinsList;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "My Pins",
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
          if (allPins.isNotEmpty)
            for (var pin in allPins)
              ListTile(
                leading: const Icon(Icons.pin_drop_outlined),
                title: Text("Pin Near ${pin.closestBuilding}"),
                subtitle: Text(
                    "Expires at ${DateFormat('kk:mm - EEE, MMM d').format(pin.expirationTime)} \n ${pin.description}"),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditPinPage(
                              clickPin: pin,
                            )),
                  ),
                },
              ),
          if (allPins.isNotEmpty)
            const Text(
              "Tap on a pin to edit",
              textAlign: TextAlign.center,
            ),
          if (allPins.isEmpty)
            const Text(
              "You don't have any pins yet!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
        ],
      ),
    );
  }
}
