import 'dart:collection';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:ur_next_route/add_node.dart';
import 'package:ur_next_route/add_pin_modal.dart';
import 'package:ur_next_route/add_safety_pin.dart';
import 'main.dart';
import 'package:provider/provider.dart';
import 'node.dart';
import 'link.dart';
import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';

class MapEditorPage extends StatefulWidget {
  late Node startNewLink;
  late Node endNewLink;
  MapEditorPage({super.key});
  var nodeList = <Node>[];
  var linkList = <Link>[];
  int currentNode = 0;

  @override
  State<MapEditorPage> createState() => _MapEditorPageState();
}

class _MapEditorPageState extends State<MapEditorPage> {
  void addNode(Node newNode) {
    setState(() {
      widget.nodeList.add(newNode);
    });
  }

  void addLink(Link newLink) {
    setState(() {
      widget.linkList.add(newLink);
    });
  }

  void setStartNewLink(Node newNode) {
    setState(() {
      widget.startNewLink = newNode;
    });
  }

  void setEndNewLink(Node newNode) {
    setState(() {
      widget.endNewLink = newNode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Map Editor",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                print("hola");
                addLink(Link(12, 1, 2, 10, widget.startNewLink.position,
                    widget.endNewLink.position, false, false, false));
              },
              child: const Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 4, 30, 66),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 56,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: const LatLng(39.543956, -119.815827),
            initialZoom: 16,
            onTap: (tapPosition, point) => {
              showModalBottomSheet(
                context: context,
                builder: (builder) {
                  return AddNodePage(
                    position: point,
                    addNode: addNode,
                  );
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
                for (var node in widget.nodeList)
                  if (node.isInside) ...[
                    Marker(
                      point: node.position,
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        onTap: () {
                          setStartNewLink(node);
                        },
                        child: const Icon(Icons.circle_rounded,
                            color: Colors.red, size: 20),
                      ),
                    ),
                  ] else ...[
                    Marker(
                      point: node.position,
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        onTap: () {
                          setEndNewLink(node);
                        },
                        child: const Icon(Icons.circle_rounded,
                            color: Colors.black, size: 20),
                      ),
                    ),
                  ]
              ],
            ),
            PolylineLayer(
              polylines: [
                for (var link in widget.linkList)
                  Polyline(
                    borderColor: Colors.black,
                    borderStrokeWidth: 4,
                    points: [
                      link.startPos,
                      link.endPos,
                    ],
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
