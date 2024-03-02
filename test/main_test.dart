import 'package:flutter_test/flutter_test.dart';
import 'package:ur_next_route/main.dart';
import 'package:ur_next_route/path.dart';
import 'package:ur_next_route/safety_pin.dart';
import 'package:ur_next_route/start_end.dart';

void main() {
  test(
      'Given showBlueLights is false, When toggleBlueLights is called, Then showBlueLights is true',
      () async {
    // ARRANGE
    final appState = MyAppState();
    // ACT
    appState.toggleBlueLights();
    // ASSERT
    expect(appState.showBlueLights, true);
  });
  test(
      'Given showMaintenancePins is true, When toggleMaintenancePins is called, Then showMaintenancePins is false',
      () async {
    // ARRANGE
    final appState = MyAppState();
    // ACT
    appState.toggleMaintenancePins();
    // ASSERT
    expect(appState.showMaintenancePins, false);
  });
  test(
      'Given a new maintenance safety pin to add, when addSafetyPin is called it should exist in the maintenance pin list',
      () async {
    // ARRANGE
    final appState = MyAppState();
    // ACT
    SafetyPin testPin = SafetyPin("KC", LatLng(1, 1), "abcd", 1,
        "maintenancePin", DateTime.now(), DateTime.now(), 123);
    appState.addSafetyPin(testPin);
    // ASSERT
    expect(testPin, appState.maintenancePinsList[0]);
  });
  test(
      'Given a new trip/fall safety pin to add, when addSafetyPin is called it should exist in the trip/fall pin list',
      () async {
    // ARRANGE
    final appState = MyAppState();
    // ACT
    SafetyPin testPin = SafetyPin("KC", LatLng(1, 1), "abcd", 2,
        "trip/fall pin", DateTime.now(), DateTime.now(), 123);
    appState.addSafetyPin(testPin);
    // ASSERT
    expect(testPin, appState.tripFallPinsList[0]);
  });
  test(
      'Given a new safety safety pin to add, when addSafetyPin is called it should exist in the safety pin list',
      () async {
    // ARRANGE
    final appState = MyAppState();
    // ACT
    SafetyPin testPin = SafetyPin("KC", LatLng(1, 1), "abcd", 3,
        "safety concern pin", DateTime.now(), DateTime.now(), 123);
    appState.addSafetyPin(testPin);
    // ASSERT
    expect(testPin, appState.safetyHazardPinsList[0]);
  });
  
}
