import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ur_next_route/safety_pin.dart';
import 'package:intl/intl.dart';

class ShowPinModal extends StatelessWidget {
  const ShowPinModal({Key? key, required this.clickPin}) : super(key: key);
  final SafetyPin clickPin;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.43,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Pin Details",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.cancel_outlined,
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
            ListTile(
              leading: const Icon(Icons.pin_drop_outlined),
              title: Text("Near ${clickPin.closestBuilding}"),
              subtitle: const Text("Location"),
            ),
            ListTile(
              leading: const Icon(Icons.watch_later_outlined),
              title: Text(DateFormat('kk:mm - EEE, MMM d')
                  .format(clickPin.expirationTime)),
              subtitle: const Text("Expiration time"),
            ),
            if (clickPin.type == 1)
              const ListTile(
                leading: Icon(Icons.build),
                title: Text("Maintenance"),
                subtitle: Text("Pin Type"),
              ),
            if (clickPin.type == 2)
              const ListTile(
                leading: Icon(Icons.personal_injury),
                title: Text("Trip/Fall Hazard"),
                subtitle: Text("Pin Type"),
              ),
            if (clickPin.type == 3)
              const ListTile(
                leading: Icon(Icons.warning),
                title: Text("Safety Concern "),
                subtitle: Text("Pin Type"),
              ),
            ListTile(
              leading: const Icon(Icons.description),
              title: Text(clickPin.description),
              subtitle: const Text("Description"),
            ),
          ],
        ),
      ),
    );
  }
}
