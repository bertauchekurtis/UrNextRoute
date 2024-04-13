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
import 'path.dart';
import 'role.dart';
import 'admin_page.dart';

String baseURL = 'http://172.16.225.194:5000';

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
  List<LatLng> path = [];
  var initialPinGet = false;
  var initialRoleGet = false; 
  List<Role> roles = [];
  var maintenancePinsList = <SafetyPin>[];
  var tripFallPinsList = <SafetyPin>[];
  var safetyHazardPinsList = <SafetyPin>[];
  var otherUserPins = <SafetyPin>[];

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

  void addOtherUserPin(SafetyPin newPin) {
    otherUserPins.add(newPin);
  }

  void triggerUpdate() {
    notifyListeners();
  }

  void getPath() async {
    try {
      final response = await http.get(Uri.parse(
          '$baseURL/getroute?startLat=${start.position.latitude}&startLong=${start.position.longitude}&endLat=${end.position.latitude}&endLong=${end.position.longitude}'));
      if (response.statusCode == 200) {
        ourPath newPath =
            ourPath.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
        path = newPath.getPathList();
        triggerUpdate();
      } else {
        throw Exception('Failed to load path.');
      }
    } on Exception {}
  }

  void getPins() async {
    try {
      final response = await http.get(Uri.parse('$baseURL/getallpins'));
      if (response.statusCode == 200) {
        maintenancePinsList.clear();
        tripFallPinsList.clear();
        safetyHazardPinsList.clear();
        otherUserPins.clear();
        Map<String, dynamic> jsonData = json.decode(response.body);
        List<dynamic> safetyPinsJson = jsonData['pins'];
        print(response.body);
        print(safetyPinsJson);
        List<SafetyPin> newPins = safetyPinsJson
            .map((pinJson) => SafetyPin.fromJson(pinJson))
            .toList();
        print(newPins);
        var user = FirebaseAuth.instance.currentUser;
        print(user!.uid);
        for (SafetyPin pin in newPins) {
          print("also here!");
          if (pin.userUID == user!.uid) {
            addSafetyPin(pin);
          } else {
            addOtherUserPin(pin);
          }
        }
        initialPinGet = true;
        triggerUpdate();
      } else {
        throw Exception('Failed to load pins');
      }
    } on Exception {
      print("hmm");
    }
  }
   Future<List<Role>> getRoles() async {
    try {
      final response = await http.get(Uri.parse('$baseURL/getuserroles'));
      if (response.statusCode == 200) {
        roles.clear();

        Map<String, dynamic> jsonData = json.decode(response.body);
        List<dynamic> rolesJson = jsonData['roles'];

        List<Role> newRoles = rolesJson
            .map((pinJson) => Role.fromJson(pinJson))
            .toList();
        initialRoleGet = true;
        roles = newRoles;
        triggerUpdate();
        return newRoles;

      } else {
        throw Exception('Failed to load roles');
      }
    } on Exception {
      print("hmm");
    }
  throw Exception('Failed to load roles');
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
  String role = "user";
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
      final response =
          await http.get(Uri.parse('$baseURL/getrole?uuid=${user?.uid}&email=${user?.email}'));
      if (response.statusCode == 200) {
        Role r =
            Role.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
        return r.role;
      } else {
        throw Exception('Failed to load role');
      }
    } on Exception {
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
    } on Exception {
      // in the server is down, don't crash the app
      role = "user";
      showErrorMessage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    var appState = context.watch<MyAppState>();
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
      case 6:
        page = const AdminPage();
      default:
        page = const SettingsPage();
    }
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
                    title: const Text("Map"),
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.refresh),
                    title: const Text("Refresh Map"),
                    onTap: () {
                      setState(() {
                        appState.initialPinGet = false;
                        appState.triggerUpdate();
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
                  if (role == 'admin') ...[
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
                      leading: const Icon(Icons.apps),
                      title: const Text("Admin Page"),
                      onTap: () {
                        setState(() {
                          selectedIndex = 6;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text("Logout"),
                    onTap: () {
                      appState.maintenancePinsList.clear();
                      appState.safetyHazardPinsList.clear();
                      appState.otherUserPins.clear();
                      appState.tripFallPinsList.clear();
                      signOutProcess();
                      appState.initialPinGet = false;
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
