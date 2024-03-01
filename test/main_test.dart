import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:ur_next_route/main.dart';
import 'package:ur_next_route/start_end.dart';

void main() {
  test(
      'Given showBlueLights is false, When toggleBlueLights is called, Then showBlueLights is true',
      () async {
    // ARRANGE
    final appState = MyAppState();
    // ASSERT
    expect(appState.showBlueLights, true);
  });
  test(
      'Given showMaintenancePins is false, When toggleMaintenancePins is called, Then showMaintenancePins is true',
      () async {
    // ARRANGE
    final appState = MyAppState();
    // ACT
    appState.toggleBlueLights();
    // ASSERT
    expect(appState.showMaintenancePins, true);
  });
}
