import 'package:flutter_test/flutter_test.dart';
import 'package:ur_next_route/main.dart';

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
}
