import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:ur_next_route/main.dart';
import 'package:provider/provider.dart';
import 'package:ur_next_route/start_end.dart';
import 'main.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
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
                  appState.addStartEnd(StartEnd(true, point)),
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: [
                    for (var startEnd in appState.startEndList)
                      Marker(
                        point: startEnd.position,
                        width: 50,
                        height: 50,
                        child: Icon(
                          Icons.star_rate_rounded,
                          color: const Color.fromARGB(255, 48, 167, 56),
                          size: 10,
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
