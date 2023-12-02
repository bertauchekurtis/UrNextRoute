import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:ur_next_route/start_end.dart';
import 'main.dart';

class AddPinModal extends StatelessWidget {
  const AddPinModal({Key? key, required LatLng this.position})
      : super(key: key);
  final LatLng position;
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Container(
      height: MediaQuery.of(context).size.height * 0.33,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 4, 30, 66),
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 10),
            ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                tileColor: Colors.white,
                title: const Center(
                    child: Text(
                  "Set Start Point",
                  style: TextStyle(fontSize: 25),
                )),
                contentPadding: const EdgeInsets.all(10),
                onTap: () => {
                      appState.start = (StartEnd(
                        true,
                        position,
                      )),
                      appState.notifyListeners(), // should fix how this is updating (do this later)
                      Navigator.pop(context),
                    }),
            const SizedBox(
              height: 10,
            ),
            ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                tileColor: Colors.white,
                title: const Center(
                    child: Text(
                  "Set End Point",
                  style: TextStyle(fontSize: 25),
                )),
                contentPadding: const EdgeInsets.all(10),
                onTap: () => {
                      appState.end = (StartEnd(
                        false,
                        position,
                      )),
                      appState.notifyListeners(), // should fix how this is updating (do this later)
                      Navigator.pop(context),
                    }),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: Colors.white,
              title: const Center(
                  child: Text(
                "Drop Safety Pin",
                style: TextStyle(fontSize: 25),
              )),
              contentPadding: const EdgeInsets.all(10),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
