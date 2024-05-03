import 'dart:convert';

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
import 'package:uuid/uuid.dart';

class MapEditorPage extends StatefulWidget {
  Node? startNewLink;
  Node? endNewLink;
  MapEditorPage({super.key});
  var nodeList = <Node>[];
  var linkList = <Link>[];
  int currentNode = 0;
  var setStart = true;
  var uuid = const Uuid();

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

  String getNewLinkuuid() {
    while (true) {
      String newId = widget.uuid.v4();
      if (!widget.linkList.map((link) => link.edgeId).contains(newId)) {
        return newId;
      }
    }
  }

  String getNewNodeuuid() {
    while (true) {
      String newId = widget.uuid.v4();
      if (!widget.nodeList.map((node) => node.nodeId).contains(newId)) {
        return newId;
      }
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

  Future<List<Link>> importDefaultLinks() async {
    List<Link> thisLinkList = [];
    await DefaultAssetBundle.of(context)
        .loadString('assets/links.csv')
        .then((result) {
      for (String line in const LineSplitter().convert(result)) {
        List stringAsList = line.split(',');
        Link thisLink = buildLinkFromList(stringAsList);
        thisLinkList.add(thisLink);
      }
    });
    return thisLinkList;
  }

  Future<List<Node>> importDefaultNodes() async {
    List<Node> thisNodeList = [];
    await DefaultAssetBundle.of(context)
        .loadString('assets/nodes.csv')
        .then((result) {
      for (String line in const LineSplitter().convert(result)) {
        List stringAsList = line.split(',');
        Node thisNode = buildNodeFromList(stringAsList);
        thisNodeList.add(thisNode);
      }
    });
    return thisNodeList;
  }

  void importDefaultMapData() {
    importDefaultLinks().then((List<Link> linkList) {
      setState(() {
        widget.linkList = linkList;
      });
      writeLinks(linkList);
    });
    importDefaultNodes().then((List<Node> nodeList) {
      setState(() {
        widget.nodeList = nodeList;
      });
      writeNodes(nodeList);
    });
  }

  void clearMapData() {
    setState(() {
      widget.linkList.clear();
      widget.nodeList.clear();
    });
    writeNodesFromOutside();
    writeLinksFromOutside();
  }

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

  Node buildNodeFromList(List nodeInfo) {
    return Node(
        nodeInfo[0],
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
        body: 'Attached are the node and link files for the exported map.',
        subject: 'Ur Next Route Map Export',
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
                        return GetEmailModal(
                          sendEmail: exportMapViaEmail,
                          importMapData: importDefaultMapData,
                          clearMapData: clearMapData,
                        );
                      });
                },
                child: const Icon(
                  Icons.settings,
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
                        getNewNodeuuid: getNewNodeuuid,
                      );
                    },
                  ),
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.urnextroute.app',
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
                        borderColor: const Color.fromARGB(255, 4, 30, 66),
                        color: const Color.fromARGB(255, 4, 30, 66),
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
                ),
                const SimpleAttributionWidget(
                  source: Text('OpenStreetMap contributors'),
                ),
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
                        getNewLinkuuid: getNewLinkuuid,
                      );
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
                        brightnessLevel: link.brightnessLevel.toString(),
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
