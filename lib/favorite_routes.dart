import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ur_next_route/start_end.dart';
import 'main.dart';
import 'add_safety_pin.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class FavRoutesPage extends StatelessWidget {
  const FavRoutesPage({super.key});
  void removePathByID(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseURL/removepath?id=$id'));
      if (response.statusCode == 200) {
      } else {
        throw Exception('Failed to remove path');
      }
    } on Exception {}
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    if (appState.initialPathGet == false) {
      appState.loadBuildings(context);
      appState.getAllPaths();
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "My Favorite Routes",
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
          if (appState.favoritePaths.isNotEmpty) ...[
            for (var path in appState.favoritePaths)
              ListTile(
                leading: GestureDetector(
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.pink,
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                                "Are you sure you want to remove this path?"),
                            content:
                                const Text("This action cannot be undone."),
                            actions: [
                              ElevatedButton(
                                onPressed: () => {
                                  appState.favoritePaths.remove(path),
                                  if (appState.pathObj != null &&
                                      appState.pathObj == path)
                                    {
                                      appState.isFavPath = false,
                                    },
                                  removePathByID(path.id),
                                  appState.triggerUpdate(),
                                  Navigator.pop(context),
                                },
                                child: const Text("Yes"),
                              ),
                              ElevatedButton(
                                onPressed: () => {
                                  Navigator.pop(context),
                                },
                                child: const Text("No"),
                              )
                            ],
                          );
                        });
                  },
                ),
                title: Text(
                    "From ${appState.getClosestBuilding(path.getPathList()[0])} to ${appState.getClosestBuilding(path.getPathList()[path.getPathList().length - 1])}"),
                subtitle: Text("Tap to Open on Map"),
                trailing: const Icon(Icons.directions_outlined),
                onTap: () => {
                  appState.pathObj = path,
                  appState.path = path.getPathList(),
                  appState.isFavPath = true,
                  appState.selectedIndex = 0,
                  appState.start = StartEnd(true, path.getPathList()[0]),
                  appState.end = StartEnd(
                      false, path.getPathList()[path.getPathList().length - 1]),
                  appState.triggerUpdate(),
                },
              ),
          ] else ...[
            const Text(
              "You don't have any favorite paths yet!",
              textAlign: TextAlign.center,
            ),
          ]
        ],
      ),
    );
  }
}
