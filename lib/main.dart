import 'dart:convert';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ur_next_route/blue_light.dart';
import 'package:ur_next_route/map_editor.dart';
import 'package:ur_next_route/safety_pin.dart';
import 'firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sign_in.dart';
import 'map.dart';
import 'route_settings.dart';
import 'my_pins.dart';
import 'safety_toolkit.dart';
import 'start_end.dart';
import 'settings.dart';
import 'package:http/http.dart' as http;
import 'role.dart';
String baseURL = "10.0.0.2";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
          title: 'Namer App',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 4, 30, 66)),
          ),
          home: const SignInPage()),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var showBlueLights = false;
  var startPointChosen = false;
  var endPointChosen = false;
  var showMaintenancePins = true;
  var showTripFallPins = true;
  var showSafetyHazardPins = true;
  var blueLightList = <BlueLight>[];
  var start = StartEnd(true, const LatLng(0, 0));
  var end = StartEnd(false, const LatLng(0, 0));
  var genRoute = false;

  var maintenancePinsList = <SafetyPin>[];
  var tripFallPinsList = <SafetyPin>[];
  var safetyHazardPinsList = <SafetyPin>[];

  void setStart(start) {
    start = start;
    notifyListeners();
  }

  void removePins(SafetyPin pin) {
    if (pin.type == 1) {
      maintenancePinsList.remove(pin);
    }
    if (pin.type == 2) {
      tripFallPinsList.remove(pin);
    }
    if (pin.type == 3) {
      safetyHazardPinsList.remove(pin);
    }
    notifyListeners();
  }

  void setEnd(end) {
    end = end;
  }

  void toggleBlueLights() {
    showBlueLights = !showBlueLights;
    notifyListeners();
  }

  void toggleMaintenancePins() {
    showMaintenancePins = !showMaintenancePins;
    notifyListeners();
  }

  void toggleTripFallPins() {
    showTripFallPins = !showTripFallPins;
    notifyListeners();
  }

  void toggleSafetyHazardPins() {
    showSafetyHazardPins = !showSafetyHazardPins;
    notifyListeners();
  }

  void addBlueLight(blueLight) {
    blueLightList.add(blueLight);
  }

  void addSafetyPin(SafetyPin newPin) {
    switch (newPin.type) {
      case 1:
        // maintenance
        maintenancePinsList.add(newPin);
        break;
      case 2:
        // trip/fall
        tripFallPinsList.add(newPin);
        break;
      case 3:
        // safety
        safetyHazardPinsList.add(newPin);
        break;
    }
    notifyListeners();
  }

  void triggerUpdate() {
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var selectedIndex = 0;
  final user = FirebaseAuth.instance.currentUser;
  String role = "Kurtis";
  bool showErrorMessage = false;
  late final name = user?.providerData.first.displayName;
  late final email = user?.providerData.first.email;
  late final photoURL = user?.providerData.first.photoURL;

  void signOutProcess() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  Future<String> fetchRole() async {
    try {
      final response = await http
          .get(Uri.parse('http://$baseURL:5000/getrole?uuid=${user?.uid}'));
      if (response.statusCode == 200) {
        Role r =
            Role.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
        return r.role;
      } else {
        throw Exception('Failed to load role');
      }
    } on Exception catch (e) {
      print("caught the exception");
      return "user";
    }
  }

  @override
  void initState() {
    super.initState();
    try {
      fetchRole().then((String result) {
        if (mounted) {
          setState(() {
            role = result;
          });
        }
      });
    } on Exception catch (e) {
      // in the server is down, don't crash the app
      role = "user";
      showErrorMessage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    print(role);
    switch (selectedIndex) {
      // SHOULD REPLACE THESE INDEXES WITH AN ENUM
      case 0:
        page = const MapPage();
      case 1:
        page = const RouteSettingsPage();
      case 2:
        page = const MyPinsPage();
      case 3:
        page = const SafetyToolKit();
      case 4:
        page = const SettingsPage();
      case 5:
        page = MapEditorPage();
      default:
        page = const SettingsPage();
    }
    print(role);
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        child: Container(
          color: const Color.fromARGB(255, 4, 30, 66),
          child: SafeArea(
            child: Container(
              color: Colors.white,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 4, 30, 66),
                    ),
                    accountName: Text(
                      name!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    accountEmail: Text(
                      email!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    currentAccountPicture: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(photoURL!),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.map_outlined),
                    title: Text(role),
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                      leading: const Icon(Icons.route_outlined),
                      title: const Text("Route Settings"),
                      onTap: () {
                        setState(() {
                          selectedIndex = 1;
                        });
                        Navigator.pop(context);
                      }),
                  ListTile(
                    leading: const Icon(Icons.pin_drop_outlined),
                    title: const Text("My Pins"),
                    onTap: () {
                      setState(() {
                        selectedIndex = 2;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.business_center_sharp),
                    title: const Text("Safety Toolkit"),
                    onTap: () {
                      setState(() {
                        selectedIndex = 3;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: const Text("Settings"),
                    onTap: () {
                      setState(() {
                        selectedIndex = 4;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.maps_home_work),
                    title: const Text("Map Editor"),
                    onTap: () {
                      setState(() {
                        selectedIndex = 5;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text("Logout"),
                    onTap: () {
                      signOutProcess();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: page,
    );
  }
}
