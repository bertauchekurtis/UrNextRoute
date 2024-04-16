import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:ur_next_route/modals/add_pin_modal.dart';
import 'main.dart';
import 'package:provider/provider.dart';
import 'blue_light.dart';
import 'dart:convert';
import 'modals/show_pin_modal.dart';
import 'start_end.dart';
import 'link.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  Future<int> addPathAndGetID(String newPath) async {
    var uuid = FirebaseAuth.instance.currentUser?.uid;
    try {
      final response = await http
          .get(Uri.parse('$baseURL/addpath?uuid=$uuid&path=$newPath'));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = json.decode(response.body);
        return jsonMap['id'];
      } else {
        throw Exception('Failed to save path');
      }
    } on Exception {
      return -1;
    }
  }

  void removePathByID(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseURL/removepath?id=$id'));
      if (response.statusCode == 200) {
      } else {
        throw Exception('Failed to remove path');
      }
    } on Exception {}
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    if (appState.initialPinGet == false) {
      appState.getPins();
    }
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

    List<Link> linkList = [];

    Link buildLinkFromList(List linkInfo) {
      return Link(
          linkInfo[0],
          linkInfo[1],
          linkInfo[2],
          double.parse(linkInfo[3]),
          LatLng(double.parse(linkInfo[4]), double.parse(linkInfo[5])),
          LatLng(double.parse(linkInfo[6]), double.parse(linkInfo[7])),
          bool.parse(linkInfo[8]),
          bool.parse(linkInfo[9]),
          bool.parse(linkInfo[10]),
          double.parse(linkInfo[11]));
    }

    Future<List<String>> heatLinks(context) async {
      List<String> questions = [];
      await DefaultAssetBundle.of(context)
          .loadString('assets/links.csv')
          .then((q) {
        for (String i in const LineSplitter().convert(q)) {
          var allThree = i.split(',');
          questions.add(i);
          //print(allThree);
          Link thisLink = buildLinkFromList(allThree);
          linkList.add(thisLink);
          appState.heatLinkList.add(thisLink);
        }
      });
      return questions;
    }

    Color convertBrightnessToColor(double brightness) {
      if (brightness < 3) {
        return Color.fromARGB(44, 176, 4, 4);
      }
      if (brightness < 6 && brightness > 3) {
        return Color.fromARGB(44, 226, 66, 17);
      }
      if (brightness < 15 && brightness > 6) {
        return Color.fromARGB(45, 234, 157, 14);
      }
      if (brightness < 30 && brightness > 15) {
        return Color.fromARGB(46, 243, 205, 37);
      }
      if (brightness < 60) {
        return Color.fromARGB(46, 214, 232, 51);
      }
      if (brightness < 90) {
        return Color.fromARGB(46, 191, 219, 142);
      }
      if (brightness < 120) {
        return Color.fromARGB(48, 153, 236, 105);
      }
      if (brightness < 150) {
        return Color.fromARGB(47, 135, 231, 164);
      }
      if (brightness < 180) {
        return Color.fromARGB(49, 127, 205, 202);
      }
      if (brightness < 210) {
        return Color.fromARGB(48, 103, 165, 159);
      }
      if (brightness < 240) {
        return Color.fromARGB(47, 173, 147, 221);
      }
      if (brightness < 270) {
        return Color.fromARGB(48, 198, 188, 237);
      } else {
        return Color.fromARGB(48, 237, 229, 247);
      }
    }

    heatLinks(context);

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
                cameraConstraint: CameraConstraint.contain(
                    bounds: LatLngBounds(const LatLng(39.567396, -119.835296),
                        const LatLng(39.525842, -119.798912))),
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
                PolylineLayer(
                  polylines: [
                    if (appState.path.isNotEmpty)
                      Polyline(
                        borderColor: const Color.fromARGB(255, 4, 30, 66),
                        borderStrokeWidth: 6,
                        points: appState.path,
                        color: const Color.fromARGB(255, 2, 42, 99),
                      ),
                    if (appState.showHeatMap)
                      for (var link in appState.heatLinkList)
                        Polyline(
                            points: [link.startPos, link.endPos],
                            color:
                                convertBrightnessToColor(link.brightnessLevel),
                            strokeWidth: 25)
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
                        size: 25,
                      ),
                    ),
                    Marker(
                      point: appState.end.position,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.star_rate_rounded,
                        color: Color.fromARGB(255, 113, 128, 138),
                        size: 25,
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
                              Icons.build,
                              color: Color.fromARGB(255, 61, 66, 87),
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
                              Icons.personal_injury,
                              color: Color.fromARGB(255, 88, 171, 255),
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
                              Icons.warning,
                              color: Color.fromARGB(255, 245, 10, 10),
                              size: 20,
                            ),
                          ),
                        ),
                    if (true) //change this to a setting for other users pins
                      for (var pin in appState.otherUserPins)
                        if(pin.type == 1) ... [
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
                                Icons.build,
                                color: Color.fromARGB(255, 61, 66, 87),
                                size: 20,
                              ),
                            ),
                          ),
                        ] else 
                        if(pin.type == 2) ... [
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
                                Icons.personal_injury,
                                color: Color.fromARGB(255, 88, 171, 255),
                                size: 20,
                              ),
                            ),
                          ),
                        ] else
                        if(pin.type == 3)
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
                                Icons.warning,
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
          Positioned(
            right: 12,
            bottom: 12,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color.fromARGB(255, 211, 224, 241),
                  backgroundColor: Color.fromARGB(255, 4, 30, 66),
                ),
                onPressed: () {
                  print("pressed");
                  appState.initialPinGet = false;
                  appState.triggerUpdate();
                },
                child: const Icon(Icons.refresh)),
          ),
          if (appState.path.isNotEmpty) ...[
            Positioned(
              right: 12,
              top: 12,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color.fromARGB(255, 211, 224, 241),
                  backgroundColor: Color.fromARGB(255, 4, 30, 66),
                ),
                onPressed: () => {
                  print("pressed"),
                  appState.genRoute = false,
                  appState.startPointChosen = false,
                  appState.endPointChosen = false,
                  appState.path = [],
                  appState.start = StartEnd(true, const LatLng(0, 0)),
                  appState.end = StartEnd(false, const LatLng(0, 0)),
                  appState.isFavPath = false,
                  appState.triggerUpdate(),
                },
                child: const Text("Clear Route"),
              ),
            ),
            if (!appState.isFavPath) ...[
              Positioned(
                right: 140,
                top: 12,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 4, 30, 66),
                  ),
                  onPressed: () => {
                    appState.isFavPath = !appState.isFavPath,
                    appState.favoritePaths.add(appState.pathObj),
                    addPathAndGetID(appState.pathObj.pathString)
                        .then((int result) {
                      appState.pathObj.id = result;
                    }),
                    appState.triggerUpdate(),
                  },
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                ),
              )
            ] else ...[
              Positioned(
                right: 140,
                top: 12,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 4, 30, 66),
                  ),
                  onPressed: () => {
                    print("Saved button"),
                    appState.isFavPath = !appState.isFavPath,
                    removePathByID(appState.pathObj.id),
                    appState.favoritePaths.remove(appState.pathObj),
                    appState.triggerUpdate(),
                  },
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.pink,
                  ),
                ),
              ),
            ],
          ],
          if (appState.startPointChosen &&
              appState.endPointChosen &&
              !appState.genRoute)
            Positioned(
              bottom: 100,
              left: MediaQuery.of(context).size.width / 2 - 100,
              width: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color.fromARGB(255, 211, 224, 241),
                  backgroundColor: Color.fromARGB(255, 4, 30, 66),
                ),
                onPressed: () => {
                  appState.genRoute = true,
                  print(appState.pathSensitivity),
                  appState.getPath(),
                },
                child: const Text("Generate Route"),
              ),
            ),
        ],
      ),
    );
  }
}
