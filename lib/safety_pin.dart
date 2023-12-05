import 'package:latlong2/latlong.dart';

class SafetyPin { 
  String closestBuilding = "placeholder";
  LatLng position = const LatLng(0, 0);
  String userUID = "";
  DateTime placedTime = DateTime(2023);
  DateTime expirationTime = DateTime(2024);
  int type = 0;
  String description = "";

  SafetyPin(this.closestBuilding, 
  this.position, 
  this.userUID, 
  this.type, 
  this.description,
  this.placedTime, 
  this.expirationTime,);
}