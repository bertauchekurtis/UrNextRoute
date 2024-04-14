import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'role.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'dart:convert';

class RoleEditing extends StatefulWidget{
  const RoleEditing({super.key});
 
  @override
  State<RoleEditing> createState() => _RoleEditingState();
}

class _RoleEditingState extends State<RoleEditing> {

  var allUsers = <Role>[];
  late String roleChange;

  Future<List<Role>> getRoles() async {
    try {
      final response = await http.get(Uri.parse('$baseURL/getuserroles'));
      if (response.statusCode == 200) {
        allUsers.clear();

        Map<String, dynamic> jsonData = json.decode(response.body);
        List<dynamic> rolesJson = jsonData['roles'];

        List<Role> newRoles = rolesJson
            .map((pinJson) => Role.fromJson(pinJson))
            .toList();

        return newRoles;

      } else {
        throw Exception('Failed to load roles');
      }
    } on Exception {
      print("hmm");
    }
  throw Exception('Failed to load roles');
  }

  // @override
  @override
  Widget build(BuildContext context) {
      // getRoles().then((List<Role> roleList){
      //  print(roleList);
      //  widget.allUsers = roleList;
      // }  );
      var appState = context.watch<MyAppState>();
      if(appState.initialRoleGet == false){
        appState.getRoles();
      }
      //print(appState.roles[0].email);
      return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Role Editing Page",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 4, 30, 66),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          for (var role in appState.roles) ... [
            if(role.role == 'admin')
            ListTile(
              title: Text(role.email),
              subtitle: Text(role.role),
              trailing: const Icon(Icons.person),
              
              onTap: () => {
                  showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Confirm to Change User's Role to User"),
                    content: StatefulBuilder(builder: (context, setState) {
                      return SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                          ],
                        ),
                      );
                    }),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            setState(() {
                                if(role.role == 'admin'){
                                  roleChange = 'admin';
                                  role.role = 'user';
                                  print(role.role);
                                }
                                else{
                                  roleChange = 'user';
                                  role.role = 'admin'; 
                                  print(role.role);
                                }
                              try {
                                http.get(Uri.parse(
                                    '$baseURL/updateroles?id=${role.id}&new_role=${role.role}'));
                              } on Exception {
                                // pass
                              }
                            });
                            appState.triggerUpdate();
                            Navigator.pop(context);
                          },
                          child: const Text('Confirm')),
                      TextButton(
                          onPressed: () => {
                                Navigator.pop(context),
                              },
                          child: const Text('Cancel'))
                    ],
                  ),
                  ),
                },
            ),
            if(role.role =='user')
            ListTile(
              title: Text(role.email),
              subtitle: Text(role.role),
              trailing: const Icon(Icons.person),
              
              onTap: () => {
                  showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Confirm to Change User's Role to Admin"),
                    content: StatefulBuilder(builder: (context, setState) {
                      return SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                          ],
                        ),
                      );
                    }),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            setState(() {
                                if(role.role == 'admin'){
                                  roleChange = 'admin';
                                  role.role = 'user';
                                  print(role.role);
                                }
                                else{
                                  roleChange = 'user';
                                  role.role = 'admin'; 
                                  print(role.role);
                                }
                              try {
                                http.get(Uri.parse(
                                    '$baseURL/updateroles?id=${role.id}&new_role=${role.role}'));
                              } on Exception {
                                // pass
                              }
                            });
                            appState.triggerUpdate();
                            Navigator.pop(context);
                          },
                          child: const Text('Confirm')),
                      TextButton(
                          onPressed: () => {
                                Navigator.pop(context),
                              },
                          child: const Text('Cancel'))
                    ],
                  ),
                  ),
                },
            ),
          ]
        ]
        ),
      );
    }
}