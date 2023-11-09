import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
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
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      // SHOULD REPLACE THESE INDEXES WITH AN ENUM
      case 0:
        page = const MapPage();
      case 1:
        page = RouteSettingsPage();
      case 2:
        page = const MyPinsPage();
      default:
        page = const EditPinPage();
    }

    return Scaffold(
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
                  const UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 4, 30, 66),
                    ),
                    accountName: Text(
                      "Test User",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    accountEmail: Text(
                      "TestUser@nevada.unr.edu",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    currentAccountPicture: FlutterLogo(),
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
                      leading: const Icon(Icons.settings_outlined),
                      title: const Text("Settings"),
                      onTap: () {
                        setState(() {
                          selectedIndex = 3;
                        });
                        Navigator.pop(context);
                      })
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

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(39.543956, -119.815827),
                initialZoom: 15,
                keepAlive: true,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: const LatLng(39.539886, -119.812539),
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.push_pin,
                        color: Colors.blue.shade900,
                        size: 50,
                      ),
                    ),
                    const Marker(
                      point: LatLng(39.540308, -119.815999),
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.push_pin,
                        color: Colors.red,
                        size: 50,
                      ),
                    ),
                    Marker(
                      point: const LatLng(39.542138, -119.815463),
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.push_pin,
                        color: Colors.blue.shade900,
                        size: 50,
                      ),
                    ),
                    Marker(
                      point: const LatLng(39.536554, -119.814330),
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.push_pin,
                        color: Colors.blue.shade900,
                        size: 50,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 12,
            top: 12,
            child: IconButton(
              iconSize: 32,
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu),
            ),
          ),
        ],
      ),
    );
  }
}

class RouteSettingsPage extends StatelessWidget {
  RouteSettingsPage({super.key});
  final credential = signInWithGoogle();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Route Settings",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.dehaze,
            color: Colors.white,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        backgroundColor: const Color.fromARGB(255, 4, 30, 66),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            leading: const Icon(
              Icons.light_mode_outlined,
              size: 30,
            ),
            title: Slider(
              value: 0.2,
              onChanged: (value) {},
            ),
            subtitle: const Text(
              "Path Brightness Preference",
              textAlign: TextAlign.center,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.light_sharp,
              size: 30,
              color: Colors.blue,
            ),
            title: Slider(
              value: 0.3,
              onChanged: (value) {},
            ),
            subtitle: const Text(
              "Emergency Blue Light Closeness",
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(
            color: Color.fromARGB(255, 4, 30, 66),
          ),
          ListTile(
            leading: const Icon(
              Icons.stairs,
              size: 30,
            ),
            title: const Text("Allow routing with Stairs"),
            trailing: Switch(
              value: true,
              onChanged: (bool value) {},
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.store,
              size: 30,
            ),
            title: const Text("Allow routing through buildings"),
            trailing: Switch(
              value: false,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.pin_drop,
              size: 30,
            ),
            title: const Text("Allow routing near maintenance pins"),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          )
        ],
      ),
    );
  }
}

class MyPinsPage extends StatelessWidget {
  const MyPinsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "My Pins",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.dehaze,
            color: Colors.white,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        backgroundColor: const Color.fromARGB(255, 4, 30, 66),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: const [
          ListTile(
            leading: Icon(Icons.pin_drop_outlined),
            title: Text("Pin Near WPEB Engineering"),
            subtitle: Text("Expires in 2 hours 12 minutes"),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            leading: Icon(Icons.pin_drop_outlined),
            title: Text("Pin Near PSAC"),
            subtitle: Text("Expires in 2 hours 32 minutes"),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            leading: Icon(Icons.pin_drop_outlined),
            title: Text("Pin Near Raggio Building"),
            subtitle: Text("Expires in 4 hours 36 minutes"),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            leading: Icon(Icons.pin_drop_outlined),
            title: Text("Pin Near Gateway Parking Garage"),
            subtitle: Text("Expires in 2 days"),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          Text(
            "Tap on a pin to edit",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

class EditPinPage extends StatelessWidget {
  const EditPinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Edit Pin",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.dehaze,
            color: Colors.white,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        backgroundColor: const Color.fromARGB(255, 4, 30, 66),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const ListTile(
            leading: Icon(Icons.pin_drop_outlined),
            title: Text("Near WPEB Engineering"),
            subtitle: Text("Location"),
            trailing: Icon(Icons.edit),
          ),
          const ListTile(
            leading: Icon(Icons.watch_later_outlined),
            title: Text("Expires in 2 hours 32 minutes"),
            subtitle: Text("Expiration time"),
            trailing: Icon(Icons.edit),
          ),
          const ListTile(
            leading: Icon(Icons.build),
            title: Text("Maintenance Pin"),
            subtitle: Text("Pin Type"),
            trailing: Icon(Icons.edit),
          ),
          const ListTile(
            leading: Icon(Icons.description),
            title: Text("Loose Handrailing"),
            subtitle: Text("Description"),
            trailing: Icon(Icons.edit),
          ),
          const Text(
            "Tap on a property to edit",
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 420,
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(39.539961, -119.812230),
                initialZoom: 18,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(markers: [
                  Marker(
                    point: const LatLng(39.539961, -119.812230),
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.push_pin,
                      color: Colors.blue.shade900,
                      size: 60,
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
