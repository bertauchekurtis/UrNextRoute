import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:ur_next_route/add_pin_modal.dart';
import 'package:ur_next_route/start_end.dart';
import 'main.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'blue_light.dart';
import 'dart:convert';

class MapPage extends StatelessWidget {
  const MapPage({super.key});
  

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    List<BlueLight> blueLightList = [];

    Future<List<String>> loadBlueLights(context) async {
      List<String> questions = [];
      await DefaultAssetBundle.of(context).loadString('assets/blue_light_data.csv').then((q) {
        for (String i in LineSplitter().convert(q)) {
          var allThree = i.split(',');
          questions.add(i);
          //print(allThree);
          BlueLight thisBlue = BlueLight(allThree[0], LatLng(double.parse(allThree[1]), double.parse(allThree[2])));
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
                initialCenter: LatLng(39.543956, -119.815827),
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
                MarkerLayer(
                  markers: [
                    Marker(
                      point: appState.start.position,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.star_rate_rounded,
                        color: const Color.fromARGB(255, 48, 167, 56),
                        size: 50,
                      ),
                    ),
                    Marker(
                      point: appState.end.position,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.star_rate_rounded,
                        color: Color.fromARGB(255, 167, 52, 48),
                        size: 50,
                    ),
                    if(appState.showBlueLights)
                    for (var blueLight in appState.blueLightList)
                    Marker(
                      point: blueLight.position,
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.flare_rounded,
                        color: Color.fromARGB(255, 3, 98, 188),
                        size: 20,
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
        ],
      ),
    );
  }
}