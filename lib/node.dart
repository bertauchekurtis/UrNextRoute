import 'package:latlong2/latlong.dart';

class Node {
  String nodeId = "";
  LatLng position = const LatLng(0, 0);
  bool isInside = false;

  Node(
    this.nodeId,
    this.position,
    this.isInside
  );
}