import 'package:flutter/material.dart';
import 'role.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'dart:convert';

class RoleEditing extends StatefulWidget{
  RoleEditing({super.key});

  var allUsers = <Role>[];

  @override
  State<RoleEditing> createState() => _RoleEditingState();
}

class _RoleEditingState extends State<RoleEditing> {
  Future<List<Role>> getRoles() async {
  
    try {
      final response = await http.get(Uri.parse('$baseURL/getuserroles'));
      if (response.statusCode == 200) {
        widget.allUsers.clear();

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
  // void initState(){
  //   super.initState();
  //   getRoles().then((List<Role> roleList){
  //     print(roleList);
  //     setState(() {
  //       widget.allUsers = roleList;
  //     });
  //   }  );
  //   print(widget.allUsers);
  //   print("here");
  // }
  @override
  Widget build(BuildContext context) {
      getRoles().then((List<Role> roleList){
       print(roleList);
       widget.allUsers = roleList;
      }  );
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
          for (var role in widget.allUsers)
            ListTile(
              title: Text("HELLO"),
              trailing: const Icon(Icons.access_alarm),
            ),
          ListTile(
            title: Text("HELLO"),
            trailing: const Icon(Icons.access_alarm),
          )  
        ]
        ),
      );
    }
}