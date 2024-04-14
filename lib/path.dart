import 'package:latlong2/latlong.dart';

class ourPath {
  final String pathString;
  double length;
  int id;

  ourPath({
    required this.pathString,
    this.length = -1,
    this.id = -1,
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
      {
        "id": int id,
        "uuid": String uuid,
        "path": String path,
      } => 
        ourPath(
          id: id, 
          pathString: path),
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
