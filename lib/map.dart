import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'blue_light.dart';
import 'dart:convert';

class MapPage extends StatelessWidget {
  const MapPage({super.key});
  

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    List<String> questions = [];
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
    //print(questions);
    //print(blueLightList);

    return SafeArea(
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(39.543956, -119.815827),
                initialZoom: 15,
                keepAlive: true,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: const LatLng(39.539886, -119.812539),
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.push_pin,
                        color: Colors.blue.shade900,
                        size: 50,
                      ),
                    ),
                    const Marker(
                      point: LatLng(39.540308, -119.815999),
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.push_pin,
                        color: Colors.red,
                        size: 50,
                      ),
                    ),
                    Marker(
                      point: const LatLng(39.542138, -119.815463),
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.push_pin,
                        color: Colors.blue.shade900,
                        size: 50,
                      ),
                    ),
                    Marker(
                      point: const LatLng(39.536554, -119.814330),
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.push_pin,
                        color: Colors.blue.shade900,
                        size: 50,
                      ),
                    ),
                    if(appState.showBlueLights)
                    for (var blueLight in appState.blueLightList)
                    Marker(
                      point: blueLight.position,
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.push_pin,
                        color: Colors.purple.shade900,
                        size: 50,
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



