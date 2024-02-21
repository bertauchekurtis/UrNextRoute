import 'package:latlong2/latlong.dart';

class Link {
  String edgeId = "";
  String startingNodeId = "";
  String endingNodeId = "";
  double brightnessLevel = 0;
  LatLng startPos = const LatLng(0, 0);
  LatLng endPos = const LatLng(0, 0);
  bool isInside = false;
  bool containsBlueLight = false;
  bool containsStairs = false;
  double length = 0;

  Link(
    this.edgeId,
    this.startingNodeId,
    this.endingNodeId,
    this.brightnessLevel,
    this.startPos,
    this.endPos,
    this.isInside,
    this.containsBlueLight,
    this.containsStairs,
    this.length,
  );
}
