import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class ParkingScreen extends StatefulWidget {
  @override
  _ParkingScreenState createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  Map<String, String> slotStatus = {
    "Slot 1": "Loading...",
    "Slot 2": "Loading...",
    "Slot 3": "Loading...",
  };

  @override
  void initState() {
    super.initState();
    _listenToSlotChanges();
  }

  void _listenToSlotChanges() {
    _database.child('sensor_data').onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        setState(() {
          slotStatus["Slot 1"] =
              data["Slot 1"]["value"] == 1 ? "Available" : "Booked";
          slotStatus["Slot 2"] =
              data["Slot 2"]["value"] == 1 ? "Available" : "Booked";
          slotStatus["Slot 3"] =
              data["Slot 3"]["value"] == 1 ? "Available" : "Booked";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parking System'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: slotStatus.entries.map((entry) {
            return Card(
              child: ListTile(
                title: Text(entry.key),
                subtitle: Text(entry.value),
                leading: Icon(
                  entry.value == "Available"
                      ? Icons.cancel
                      : Icons.check_circle,
                  color: entry.value == "Available" ? Colors.red : Colors.green,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
