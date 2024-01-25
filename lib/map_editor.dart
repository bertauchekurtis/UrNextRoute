import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:ur_next_route/modals/add_link_modal.dart';
import 'package:ur_next_route/modals/add_node.dart';
import 'package:ur_next_route/modals/edit_link_modal.dart';
import 'package:ur_next_route/modals/edit_node.dart';
import 'package:ur_next_route/modals/get_email_modal.dart';
import 'node.dart';
import 'link.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

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
    writeNodes(widget.nodeList);
  }

  void addLink(Link newLink) {
    setState(() {
      widget.linkList.add(newLink);
    });
    writeLinks(widget.linkList);
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
    writeLinksFromOutside();
    writeNodesFromOutside();
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

  Color convertBrightnessToColor(int brightness) {
    switch (brightness) {
      case 0:
        return const Color.fromARGB(255, 29, 31, 36);
      case 1:
        return const Color.fromARGB(255, 46, 45, 80);
      case 2:
        return const Color.fromARGB(255, 74, 72, 131);
      case 3:
        return const Color.fromARGB(255, 87, 111, 166);
      case 4:
        return const Color.fromARGB(255, 87, 132, 166);
      case 5:
        return const Color.fromARGB(255, 87, 166, 164);
      case 6:
        return const Color.fromARGB(255, 87, 166, 140);
      case 7:
        return const Color.fromARGB(255, 87, 166, 115);
      case 8:
        return const Color.fromARGB(255, 87, 166, 94);
      case 9:
        return const Color.fromARGB(255, 104, 171, 92);
      case 10:
        return const Color.fromARGB(255, 80, 206, 58);
      default:
        return const Color.fromARGB(255, 80, 206, 58);
    }
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

  void writeNodesFromOutside() {
    writeNodes(widget.nodeList);
  }

  void writeLinksFromOutside() {
    writeLinks(widget.linkList);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _linkFile async {
    final path = await _localPath;
    return File('$path/links.csv');
  }

  Future<File> get _nodeFile async {
    final path = await _localPath;
    return File('$path/nodes.csv');
  }

  Future<File> writeLinks(List<Link> linkList) async {
    final file = await _linkFile;
    final stream = file.openWrite();
    for (final link in linkList) {
      final String preparedString =
          '${link.edgeId.toString()},${link.startingNodeId.toString()},${link.endingNodeId.toString()},${link.brightnessLevel.toString()},${link.startPos.latitude.toString()},${link.startPos.longitude.toString()},${link.endPos.latitude.toString()},${link.endPos.longitude.toString()},${link.isInside.toString()},${link.containsBlueLight.toString()},${link.containsStairs.toString()},${link.length.toString()}\n';
      stream.write(preparedString);
    }
    stream.close();
    return file;
  }

  Future<File> writeNodes(List<Node> nodeList) async {
    final file = await _nodeFile;
    final stream = file.openWrite();
    for (final node in nodeList) {
      final String preparedString =
          '${node.nodeId.toString()},${node.position.latitude.toString()},${node.position.longitude.toString()},${node.isInside.toString()}\n';
      stream.write(preparedString);
    }
    stream.close();
    return file;
  }

  Future<List<Link>> readLinks() async {
    List<Link> thisLinkList = [];
    try {
      final file = await _linkFile;
      final contents = await file.readAsLines();
      for (final line in contents) {
        List stringAsList = line.split(',');
        Link thisLink = buildLinkFromList(stringAsList);
        thisLinkList.add(thisLink);
      }
      return thisLinkList;
    } catch (e) {
      return thisLinkList;
    }
  }

  Future<List<Node>> readNodes() async {
    List<Node> thisNodeList = [];
    try {
      final file = await _nodeFile;
      final contents = await file.readAsLines();
      for (final line in contents) {
        List stringAsList = line.split(',');
        Node thisNode = buildNodeFromList(stringAsList);
        thisNodeList.add(thisNode);
      }
      return thisNodeList;
    } catch (e) {
      return thisNodeList;
    }
  }

  Link buildLinkFromList(List linkInfo) {
    return Link(
        int.parse(linkInfo[0]),
        int.parse(linkInfo[1]),
        int.parse(linkInfo[2]),
        int.parse(linkInfo[3]),
        LatLng(double.parse(linkInfo[4]), double.parse(linkInfo[5])),
        LatLng(double.parse(linkInfo[6]), double.parse(linkInfo[7])),
        bool.parse(linkInfo[8]),
        bool.parse(linkInfo[9]),
        bool.parse(linkInfo[10]),
        double.parse(linkInfo[11]));
  }

  Node buildNodeFromList(List nodeInfo) {
    return Node(
        int.parse(nodeInfo[0]),
        LatLng(double.parse(nodeInfo[1]), double.parse(nodeInfo[2])),
        bool.parse(nodeInfo[3]));
  }

  @override
  void initState() {
    super.initState();
    readLinks().then((List<Link> linkList) {
      setState(() {
        widget.linkList = linkList;
      });
    });
    readNodes().then((List<Node> nodeList) {
      setState(() {
        widget.nodeList = nodeList;
      });
    });
  }

  void exportMapViaEmail(String emailAddress) async {
    final path = await _localPath;
    String nodePath = '$path/nodes.csv';
    String linkPath = '$path/links.csv';

    final Email email = Email(
        body: 'Email body',
        subject: 'Subject',
        recipients: [emailAddress],
        attachmentPaths: [nodePath, linkPath],
        isHTML: false);
    await FlutterEmailSender.send(email);
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
          if (widget.startNewLink != null && widget.endNewLink != null) ...[
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
          ] else ...[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (builder) {
                        return GetEmailModal(sendEmail: exportMapViaEmail);
                      });
                },
                child: const Icon(
                  Icons.cloud_upload,
                  color: Colors.white,
                ),
              ),
            ),
          ]
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
                                        writeNodes: writeNodesFromOutside,
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
                                        writeNodes: writeNodesFromOutside,
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
                        borderColor:
                            convertBrightnessToColor(link.brightnessLevel),
                        color: convertBrightnessToColor(link.brightnessLevel),
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
                        writeLinks: writeLinksFromOutside,
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
