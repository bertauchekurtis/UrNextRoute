import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'package:intl/intl.dart';
import 'edit_pin.dart';

class AllPins extends StatefulWidget{
  AllPins({super.key});
  DateTime currentDate = DateTime.now();
  @override
  State<AllPins> createState() => _AllPinsState();
}

class _AllPinsState extends State<AllPins> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var allPins = appState.maintenancePinsList +
        appState.tripFallPinsList +
        appState.safetyHazardPinsList + appState.otherUserPins;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "All Pins",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
           Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 4, 30, 66),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (allPins.isNotEmpty)
            for (var pin in allPins)
            //if(pin.expirationTime.compareTo(widget.currentDate) > 0)
            //    appState.removePins(pin),
            //else
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
              "There are no pins placed on the map!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
        ],
      ),
    );
  }
}
