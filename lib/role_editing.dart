import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'role.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'dart:convert';

class RoleEditing extends StatelessWidget{
  RoleEditing({super.key});

  var allUsers = <Role>[];
  
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
          for (var role in appState.roles)
            ListTile(
              title: Text(role.email),
              subtitle: Text(role.role),
              trailing: const Icon(Icons.person),
            ),
        ]
        ),
      );
    }
}