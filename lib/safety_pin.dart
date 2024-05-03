import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class SafetyPin {
  String closestBuilding = "placeholder";
  LatLng position = const LatLng(0, 0);
  String userUID = "";
  DateTime placedTime = DateTime(2023);
  DateTime expirationTime = DateTime(2024);
  int type = 0;
  String description = "";
  int id = -1;

  SafetyPin(
    this.closestBuilding,
    this.position,
    this.userUID,
    this.type,
    this.description,
    this.placedTime,
    this.expirationTime,
    this.id,
  );

  factory SafetyPin.fromJson(Map<String, dynamic> json){
    print("this is running");
    return switch(json){
      {
        "closestBuilding": String closestBuilding,
        "comment": String comment,
        "createDate": String placedTime,
        "expireDate": String expireDate,
        "id": int id,
        "lat": double latitude,
        "long": double longitude,
        "type": int type,
        "uuid": String uuid,
      } =>
      SafetyPin(
        closestBuilding,
        LatLng(latitude, longitude),
        uuid,
        type,
        comment,
        DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", 'en_US').parse(placedTime),
        DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", 'en_US').parse(expireDate),
        id,
      ),
      _ => throw const FormatException("Failed to load pin."),
    };
  }
}