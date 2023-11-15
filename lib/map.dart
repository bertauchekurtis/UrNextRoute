import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
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