import 'package:latlong2/latlong.dart';

class ourPath {
  final String pathString;
  final double length;

  ourPath({
    required this.pathString,
    required this.length,
  });

  factory ourPath.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "path": String pathString,
        "length": double length,
      } =>
        ourPath(
          pathString: pathString,
          length: length,
        ),
      _ => throw const FormatException('Failed to load path.'),
    };
  }
  List<LatLng> getPathList() {
    List<String> pathStringList = pathString.split(',');
    List<LatLng> pathList = [];
    for (var i = 0; i < pathStringList.length; i += 2) {
      pathList.add(LatLng(double.parse(pathStringList[i]),
          double.parse(pathStringList[i + 1])));
    }
    return pathList;
  }
}
