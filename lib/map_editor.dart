import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:ur_next_route/modals/add_link_modal.dart';
import 'package:ur_next_route/modals/add_node.dart';
import 'package:ur_next_route/modals/edit_node.dart';
import 'node.dart';
import 'link.dart';

class MapEditorPage extends StatefulWidget {
  Node? startNewLink;
  Node? endNewLink;
  MapEditorPage({super.key});
  var nodeList = <Node>[];
  var linkList = <Link>[];
  int currentNode = 0;
  var setStart = true;

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

  void setStartEndPoints(Node newNode) {
    if (widget.setStart) {
      setStartNewLink(newNode);
    } else {
      setEndNewLink(newNode);
    }
    setState(() {
      widget.setStart = !widget.setStart;
    });
  }

  void removeNode(Node oldNode) {
    setState(() {
      widget.nodeList.remove(oldNode);
      ////////////////////// ALSO NEED TO REMOVE ANY LINKS CONNECTED TO THIS NODE
    });
  }

  void removeLink(Link oldLink) {
    setState(() {
      widget.linkList.remove(oldLink);
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
                if (widget.startNewLink != null && widget.endNewLink != null) {
                  showModalBottomSheet(
                      context: context,
                      builder: (builder) {
                        return AddLinkModal(
                            startNode: widget.startNewLink!,
                            endNode: widget.endNewLink!,
                            addLink: addLink,
                            idForNewLink: 0);
                      });
                }
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
                if (widget.startNewLink != null)
                  Marker(
                    point: widget.startNewLink!.position,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.circle_rounded,
                        color: Colors.green, size: 40),
                  ),
                if (widget.endNewLink != null)
                  Marker(
                    point: widget.endNewLink!.position,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.circle_rounded,
                        color: Colors.red, size: 40),
                  ),
                for (var node in widget.nodeList)
                  if (node.isInside) ...[
                    Marker(
                      point: node.position,
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        onTap: () {
                          setStartEndPoints(node);
                        },
                        onLongPress: () {
                          setState(() {
                            showModalBottomSheet(
                                context: context,
                                builder: (builder) {
                                  return EditNodeModal(
                                    thisNode: node,
                                    isInside: node.isInside,
                                    delNode: removeNode,
                                  );
                                });
                          });
                        },
                        child: const Icon(Icons.circle_rounded,
                            color: Colors.red, size: 30),
                      ),
                    ),
                  ] else ...[
                    Marker(
                      point: node.position,
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        onTap: () {
                          setStartEndPoints(node);
                        },
                        onLongPress: () {
                          setState(() {
                            showModalBottomSheet(
                                context: context,
                                builder: (builder) {
                                  return EditNodeModal(
                                    thisNode: node,
                                    isInside: node.isInside,
                                    delNode: removeNode,
                                  );
                                });
                          });
                        },
                        child: const Icon(Icons.circle_rounded,
                            color: Colors.black, size: 30),
                      ),
                    ),
                  ],
              ],
            ),
            PolylineLayer(
              polylines: [
                for (var link in widget.linkList)
                  Polyline(
                    borderColor: Colors.black,
                    color: Colors.black,
                    borderStrokeWidth: 4,
                    points: [
                      link.startPos,
                      link.endPos,
                    ],
                  ),
                if (widget.startNewLink != null && widget.endNewLink != null)
                  Polyline(
                    isDotted: true,
                    color: Colors.black,
                    strokeWidth: 4,
                    points: [
                      widget.startNewLink!.position,
                      widget.endNewLink!.position,
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
