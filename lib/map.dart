import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:ur_next_route/modals/add_pin_modal.dart';
import 'main.dart';
import 'package:provider/provider.dart';
import 'blue_light.dart';
import 'dart:convert';
import 'modals/show_pin_modal.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    List<BlueLight> blueLightList = [];

    Future<List<String>> loadBlueLights(context) async {
      List<String> questions = [];
      await DefaultAssetBundle.of(context)
          .loadString('assets/blue_light_data.csv')
          .then((q) {
        for (String i in const LineSplitter().convert(q)) {
          var allThree = i.split(',');
          questions.add(i);
          //print(allThree);
          BlueLight thisBlue = BlueLight(allThree[0],
              LatLng(double.parse(allThree[1]), double.parse(allThree[2])));
          blueLightList.add(thisBlue);
          appState.addBlueLight(thisBlue);
        }
      });
      return questions;
    }

    loadBlueLights(context);

    return SafeArea(
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: const LatLng(39.543956, -119.815827),
                initialZoom: 15,
                keepAlive: true,
                onTap: (tapPosition, point) => {
                  //appState.addStartEnd(StartEnd(true, point)),
                  showModalBottomSheet(
                    context: context,
                    builder: (builder) {
                      return AddPinModal(position: point);
                    },
                  ),
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                if (appState.genRoute)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        borderColor: const Color.fromARGB(255, 4, 30, 66),
                        borderStrokeWidth: 6,
                        points: [
                          const LatLng(39.53952, -119.812431),
                          const LatLng(39.540165, -119.81306),
                          const LatLng(39.540129, -119.813535),
                          const LatLng(39.540893, -119.813851),
                          const LatLng(39.540866, -119.814374),
                          const LatLng(39.54106, -119.814321),
                          const LatLng(39.541282, -119.814638),
                          const LatLng(39.541241, -119.814842),
                          const LatLng(39.54196, -119.815549),
                          const LatLng(39.542679, -119.815672),
                          const LatLng(39.543545, -119.816132),
                          const LatLng(39.543837, -119.816265),
                          const LatLng(39.544245, -119.81678),
                          const LatLng(39.545019, -119.816804),
                          const LatLng(39.545381, -119.816526),
                          const LatLng(39.546188, -119.815304),
                          const LatLng(39.546396, -119.815057),
                          const LatLng(39.546873, -119.814759),
                          const LatLng(39.547312, -119.81368),
                          const LatLng(39.547518, -119.813308),
                          const LatLng(39.547537, -119.812809),
                          const LatLng(39.547721, -119.812192),
                          const LatLng(39.548412, -119.811796)
                        ],
                        color: const Color.fromARGB(255, 2, 42, 99),
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: appState.start.position,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.star_rate_rounded,
                        color: Color.fromARGB(255, 5, 106, 165),
                        size: 50,
                      ),
                    ),
                    Marker(
                      point: appState.end.position,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.star_rate_rounded,
                        color: Color.fromARGB(255, 113, 128, 138),
                        size: 50,
                      ),
                    ),
                    if (appState.showBlueLights)
                      for (var blueLight in appState.blueLightList)
                        Marker(
                          point: blueLight.position,
                          width: 50,
                          height: 50,
                          child: const Icon(
                            Icons.flare_rounded,
                            color: Color.fromARGB(255, 3, 98, 188),
                            size: 20,
                          ),
                        ),
                    if (appState.showMaintenancePins)
                      for (var pin in appState.maintenancePinsList)
                        Marker(
                          point: pin.position,
                          width: 50,
                          height: 50,
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (builder) {
                                  return ShowPinModal(
                                    clickPin: pin,
                                  );
                                },
                              );
                            },
                            child: const Icon(
                              Icons.push_pin_sharp,
                              color: Color.fromARGB(255, 229, 10, 245),
                              size: 20,
                            ),
                          ),
                        ),
                    if (appState.showTripFallPins)
                      for (var pin in appState.tripFallPinsList)
                        Marker(
                          point: pin.position,
                          width: 50,
                          height: 50,
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (builder) {
                                  return ShowPinModal(
                                    clickPin: pin,
                                  );
                                },
                              );
                            },
                            child: const Icon(
                              Icons.push_pin_sharp,
                              color: Color.fromARGB(255, 46, 135, 195),
                              size: 20,
                            ),
                          ),
                        ),
                    if (appState.showSafetyHazardPins)
                      for (var pin in appState.safetyHazardPinsList)
                        Marker(
                          point: pin.position,
                          width: 50,
                          height: 50,
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (builder) {
                                  return ShowPinModal(
                                    clickPin: pin,
                                  );
                                },
                              );
                            },
                            child: const Icon(
                              Icons.push_pin_sharp,
                              color: Color.fromARGB(255, 245, 10, 10),
                              size: 20,
                            ),
                          ),
                        ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 12,
            top: 12,
            child: IconButton(
              iconSize: 32,
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu),
            ),
          ),
          if (appState.startPointChosen &&
              appState.endPointChosen &&
              !appState.genRoute)
            Positioned(
              bottom: 100,
              left: MediaQuery.of(context).size.width / 2 - 100,
              width: 200,
              child: ElevatedButton(
                onPressed: () => {
                  appState.genRoute = true,
                  appState.triggerUpdate(),
                },
                child: const Text("Generate Route"),
              ),
            ),
        ],
      ),
    );
  }
}
