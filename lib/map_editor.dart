import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:ur_next_route/modals/add_link_modal.dart';
import 'package:ur_next_route/modals/add_node.dart';
import 'package:ur_next_route/modals/edit_link_modal.dart';
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
      widget.linkList.removeWhere((element) =>
          element.startPos == oldNode.position ||
          element.endPos == oldNode.position);
      clearNewLinkPositions();
    });
  }

  void removeLink(Link oldLink) {
    setState(() {
      widget.linkList.remove(oldLink);
    });
  }

  void clearNewLinkPositions() {
    setState(() {
      widget.startNewLink = null;
      widget.endNewLink = null;
    });
  }

  bool linkExists(Node? nodeA, Node? nodeB) {
    final thisLinkIndex = widget.linkList.indexWhere((element) =>
        (element.startPos == nodeA!.position &&
            element.endPos == nodeB!.position) ||
        (element.endPos == nodeA.position &&
            element.startPos == nodeB!.position));
    if (thisLinkIndex >= 0) {
      return true;
    }
    return false;
  }

  Link getLinkBetween(Node? nodeA, Node? nodeB) {
    final thisLink = widget.linkList.firstWhere((element) =>
        (element.startPos == nodeA!.position &&
            element.endPos == nodeB!.position) ||
        (element.endPos == nodeA.position &&
            element.startPos == nodeB!.position));
    return thisLink;
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
          if (widget.startNewLink != null && widget.endNewLink != null)
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  clearNewLinkPositions();
                },
                child: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.white,
                ),
              ),
            ),
        ],
        backgroundColor: const Color.fromARGB(255, 4, 30, 66),
      ),
      body: Stack(
        children: [
          SizedBox(
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
                    if (widget.startNewLink != null &&
                        widget.endNewLink != null)
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
          if (widget.startNewLink != null &&
              widget.endNewLink != null &&
              !linkExists(widget.startNewLink, widget.endNewLink))
            Positioned(
              bottom: 100,
              left: MediaQuery.of(context).size.width / 2 - 100,
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (builder) {
                      return AddLinkModal(
                          startNode: widget.startNewLink!,
                          endNode: widget.endNewLink!,
                          addLink: addLink,
                          idForNewLink: 0);
                    },
                  );
                },
                child: const Text("Create Link"),
              ),
            ),
          if (widget.startNewLink != null &&
              widget.endNewLink != null &&
              linkExists(widget.startNewLink, widget.endNewLink))
            Positioned(
              bottom: 100,
              left: MediaQuery.of(context).size.width / 2 - 100,
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (builder) {
                      final link = getLinkBetween(
                          widget.startNewLink, widget.endNewLink);
                      return EditLinkModal(
                        thisLink: link,
                        brightnessLevel: link.brightnessLevel.toDouble(),
                        isInside: link.isInside,
                        containsBlueLight: link.containsBlueLight,
                        containsStairs: link.containsStairs,
                        delLink: removeLink,
                      );
                    },
                  );
                },
                child: const Text("Edit Link"),
              ),
            ),
        ],
      ),
    );
  }
}
