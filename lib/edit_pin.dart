import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:ur_next_route/main.dart';
import 'package:ur_next_route/safety_pin.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'main.dart';
import 'package:http/http.dart' as http;

class EditPinPage extends StatefulWidget {
  EditPinPage({Key? key, required this.clickPin}) : super(key: key);
  SafetyPin clickPin;

  final DateTime now = DateTime.now();
  late final String formattedDate =
      DateFormat('kk:mm - EEE, MMM d').format(now);

  DateTime expireTime = DateTime.now();
  late String formattedExpireTime =
      DateFormat('kk:mm - EEE, MMM d').format(expireTime);

  @override
  State<EditPinPage> createState() => _EditPinPageState();
}

class _EditPinPageState extends State<EditPinPage> {
//  var selectedOption = widget.clickPin.type;
  final TextEditingController descriptionController = TextEditingController();
  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  String getFormattedTime(DateTime thisDate) {
    return DateFormat('kk:mm - EEE, MMM d').format(thisDate);
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Edit Pin",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Are you sure?'),
                        content: const Text(
                            'Are you sure you want to delete this pin?'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              try {
                                http.get(Uri.parse(
                                    '$baseURL/deletepin?id=${widget.clickPin.id}'));
                              } on Exception {
                                //pass
                              }
                              appState.removePins(widget.clickPin);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text('Confirm'),
                          ),
                          ElevatedButton(
                              onPressed: () => {
                                    Navigator.pop(context),
                                  },
                              child: const Text('Decline'))
                        ],
                      );
                    });
//              appState.removePins(clickPin);
                //             Navigator.pop(context);
              },
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
        ],
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
          ListTile(
            leading: const Icon(Icons.pin_drop_outlined),
            title: Text("Near ${widget.clickPin.closestBuilding}"),
            subtitle: const Text("Location"),
          ),
          ListTile(
            leading: const Icon(Icons.watch_later_outlined),
            title: Text(DateFormat('kk:mm - EEE, MMM d')
                .format(widget.clickPin.expirationTime)),
            subtitle: const Text("Expiration time"),
            trailing: const Icon(Icons.edit),
            onTap: () {
              DatePicker.showDatePicker(context,
                  dateFormat: 'HH:mm MMMM dd yyyy',
                  initialDateTime: widget.clickPin.expirationTime,
                  minDateTime: DateTime(2024),
                  maxDateTime: DateTime(2025),
                  onMonthChangeStartWithFirstDate: true,
                  onConfirm: (dateTime, List<int> index) {
                setState(() {
                  widget.clickPin.expirationTime = dateTime;
                  try {
                    http.get(Uri.parse(
                        '$baseURL/updatepin?uuid=${widget.clickPin.userUID}&type=${widget.clickPin.type}&lat=${widget.clickPin.position.latitude}&long=${widget.clickPin.position.longitude}&createDate=${widget.clickPin.placedTime.year},${widget.clickPin.placedTime.month},${widget.clickPin.placedTime.day},${widget.clickPin.placedTime.hour},${widget.clickPin.placedTime.minute}&expireDate=${widget.clickPin.expirationTime.year},${widget.clickPin.expirationTime.month},${widget.clickPin.expirationTime.day},${widget.clickPin.expirationTime.hour},${widget.clickPin.expirationTime.minute}&closestBuilding=${widget.clickPin.closestBuilding}&comment=${widget.clickPin.description}&id=${widget.clickPin.id}'));
                  } on Exception {
                    //pass
                  }
                  widget.formattedExpireTime = getFormattedTime(dateTime);
                });
                appState.triggerUpdate();
              });
            },
          ),
          if (widget.clickPin.type == 1)
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text("Maintenance"),
              subtitle: const Text("Pin Type"),
              trailing: const Icon(Icons.edit),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Change Pin Type:"),
                    content: StatefulBuilder(builder: (context, setState) {
                      return SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: const Text("Trip/Fall Hazard"),
                              leading: Radio(
                                  value: 2,
                                  groupValue: widget.clickPin.type,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.clickPin.type = value!;
                                    });
                                  }),
                            ),
                            ListTile(
                              title: const Text("Safety Concern"),
                              leading: Radio(
                                  value: 3,
                                  groupValue: widget.clickPin.type,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.clickPin.type = value!;
                                    });
                                  }),
                            ),
                          ],
                        ),
                      );
                    }),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            setState(() {
                              try {
                                http.get(Uri.parse(
                                    '$baseURL/updatepin?uuid=${widget.clickPin.userUID}&type=${widget.clickPin.type}&lat=${widget.clickPin.position.latitude}&long=${widget.clickPin.position.longitude}&createDate=${widget.clickPin.placedTime.year},${widget.clickPin.placedTime.month},${widget.clickPin.placedTime.day},${widget.clickPin.placedTime.hour},${widget.clickPin.placedTime.minute}&expireDate=${widget.clickPin.expirationTime.year},${widget.clickPin.expirationTime.month},${widget.clickPin.expirationTime.day},${widget.clickPin.expirationTime.hour},${widget.clickPin.expirationTime.minute}&closestBuilding=${widget.clickPin.closestBuilding}&comment=${widget.clickPin.description}&id=${widget.clickPin.id}'));
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
                );
              },
            ),
          if (widget.clickPin.type == 2)
            ListTile(
              leading: const Icon(Icons.personal_injury),
              title: const Text("Trip/Fall Hazard"),
              subtitle: const Text("Pin Type"),
              trailing: const Icon(Icons.edit),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Change Pin Type:"),
                    content: StatefulBuilder(builder: (context, setState) {
                      return SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: const Text("Maintenance"),
                              leading: Radio(
                                  value: 1,
                                  groupValue: widget.clickPin.type,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.clickPin.type = value!;
                                    });
                                  }),
                            ),
                            ListTile(
                              title: const Text("Safety Concern"),
                              leading: Radio(
                                  value: 3,
                                  groupValue: widget.clickPin.type,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.clickPin.type = value!;
                                    });
                                  }),
                            ),
                          ],
                        ),
                      );
                    }),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            setState(() {
                              try {
                                http.get(Uri.parse(
                                    '$baseURL/updatepin?uuid=${widget.clickPin.userUID}&type=${widget.clickPin.type}&lat=${widget.clickPin.position.latitude}&long=${widget.clickPin.position.longitude}&createDate=${widget.clickPin.placedTime.year},${widget.clickPin.placedTime.month},${widget.clickPin.placedTime.day},${widget.clickPin.placedTime.hour},${widget.clickPin.placedTime.minute}&expireDate=${widget.clickPin.expirationTime.year},${widget.clickPin.expirationTime.month},${widget.clickPin.expirationTime.day},${widget.clickPin.expirationTime.hour},${widget.clickPin.expirationTime.minute}&closestBuilding=${widget.clickPin.closestBuilding}&comment=${widget.clickPin.description}&id=${widget.clickPin.id}'));
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
                );
              },
            ),
          if (widget.clickPin.type == 3)
            ListTile(
              leading: const Icon(Icons.warning),
              title: const Text("Safety Concern"),
              subtitle: const Text("Pin Type"),
              trailing: const Icon(Icons.edit),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Change Pin Type:"),
                    content: StatefulBuilder(builder: (context, setState) {
                      return SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: const Text("Maintenance"),
                              leading: Radio(
                                  value: 1,
                                  groupValue: widget.clickPin.type,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.clickPin.type = value!;
                                    });
                                  }),
                            ),
                            ListTile(
                              title: const Text("Trip/Fall Hazard"),
                              leading: Radio(
                                  value: 2,
                                  groupValue: widget.clickPin.type,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.clickPin.type = value!;
                                    });
                                  }),
                            ),
                          ],
                        ),
                      );
                    }),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            setState(() {
                              try {
                                http.get(Uri.parse(
                                    '$baseURL/updatepin?uuid=${widget.clickPin.userUID}&type=${widget.clickPin.type}&lat=${widget.clickPin.position.latitude}&long=${widget.clickPin.position.longitude}&createDate=${widget.clickPin.placedTime.year},${widget.clickPin.placedTime.month},${widget.clickPin.placedTime.day},${widget.clickPin.placedTime.hour},${widget.clickPin.placedTime.minute}&expireDate=${widget.clickPin.expirationTime.year},${widget.clickPin.expirationTime.month},${widget.clickPin.expirationTime.day},${widget.clickPin.expirationTime.hour},${widget.clickPin.expirationTime.minute}&closestBuilding=${widget.clickPin.closestBuilding}&comment=${widget.clickPin.description}&id=${widget.clickPin.id}'));
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
                );
              },
            ),
          ListTile(
            leading: const Icon(Icons.description),
            title: Text(widget.clickPin.description),
            subtitle: const Text("Description"),
            trailing: const Icon(Icons.edit),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Enter Description"),
                  content: TextField(
                    maxLength: 120,
                    decoration:
                        InputDecoration(hintText: widget.clickPin.description),
                    controller: descriptionController,
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            widget.clickPin.description =
                                descriptionController.text;
                            try {
                              http.get(Uri.parse(
                                  '$baseURL/updatepin?uuid=${widget.clickPin.userUID}&type=${widget.clickPin.type}&lat=${widget.clickPin.position.latitude}&long=${widget.clickPin.position.longitude}&createDate=${widget.clickPin.placedTime.year},${widget.clickPin.placedTime.month},${widget.clickPin.placedTime.day},${widget.clickPin.placedTime.hour},${widget.clickPin.placedTime.minute}&expireDate=${widget.clickPin.expirationTime.year},${widget.clickPin.expirationTime.month},${widget.clickPin.expirationTime.day},${widget.clickPin.expirationTime.hour},${widget.clickPin.expirationTime.minute}&closestBuilding=${widget.clickPin.closestBuilding}&comment=${widget.clickPin.description}&id=${widget.clickPin.id}'));
                            } on Exception {
                              // pass
                            }
                          });
                          appState.triggerUpdate();
                          Navigator.pop(context);
                        },
                        child: const Text('Enter Pin Description')),
                    TextButton(
                        onPressed: () => {
                              Navigator.pop(context),
                            },
                        child: Text('Cancel'))
                  ],
                ),
              );
            },
          ),
          const Text(
            "Tap on a property to edit",
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 420,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: widget.clickPin.position,
                initialZoom: 18,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(markers: [
                  Marker(
                    point: widget.clickPin.position,
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
