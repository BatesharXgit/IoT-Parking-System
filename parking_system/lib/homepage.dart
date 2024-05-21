import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ParkingScreen extends StatefulWidget {
  @override
  _ParkingScreenState createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();
  late List<String> sensors = ['ir3', 'ir4', 'ir5'];

  void bookSlot(String sensor) {
    databaseReference.child('booking_status').update({
      '$sensor\_booked': true,
    });
  }

  void cancelBooking(String sensor) {
    databaseReference.child('booking_status').update({
      '$sensor\_booked': false,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parking System'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: sensors
                  .map(
                    (sensor) => StreamBuilder<DatabaseEvent>(
                      stream: databaseReference
                          .child('booking_status/$sensor\_booked')
                          .onValue,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          bool isBooked =
                              snapshot.data!.snapshot.value as bool? ?? false;
                          return Container(
                            width: 100,
                            height: 100,
                            color: isBooked ? Colors.red : Colors.green,
                            child: Center(
                              child: Text(
                                sensor.toUpperCase(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 20),
            for (var sensor in sensors)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => bookSlot(sensor),
                    child: Text('Book Slot $sensor'),
                  ),
                  ElevatedButton(
                    onPressed: () => cancelBooking(sensor),
                    child: Text('Cancel Booking $sensor'),
                  ),
                  SizedBox(height: 10),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
