import 'package:latlong2/latlong.dart';

class Node {
  int nodeId = 0;
  LatLng position = const LatLng(0, 0);
  bool isInside = false;

  Node(
    this.nodeId,
    this.position,
    this.isInside
  );
}