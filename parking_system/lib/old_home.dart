import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late DatabaseReference _sensorDataRef;
//   late Map<String, dynamic> _latestSensorData;

//   @override
//   void initState() {
//     super.initState();
//     _sensorDataRef = FirebaseDatabase.instance.reference().child('sensor_data');
//     _latestSensorData = {};
//     _initSensorDataListener();
//   }

//   void _initSensorDataListener() {
//     _sensorDataRef.onValue.listen((DatabaseEvent event) {
//       DataSnapshot snapshot = event.snapshot;
//       if (snapshot.value != null) {
//         Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
//         values.forEach((key, value) {
//           if (_latestSensorData.isEmpty ||
//               value['timestamp'] > _latestSensorData['timestamp']) {
//             setState(() {
//               _latestSensorData = {
//                 'sensor_id': key,
//                 'value': value['value'],
//                 'timestamp': value['timestamp'],
//               };
//             });
//           }
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Parking System'),
//       ),
//       body: _latestSensorData.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : ListTile(
//               title: Text('Sensor ID: ${_latestSensorData['sensor_id']}'),
//               subtitle: Text('Value: ${_latestSensorData['value']}'),
//               trailing: Text('Timestamp: ${_latestSensorData['timestamp']}'),
//             ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';

class SensorData {
  final String sensorId;
  final dynamic value;
  final dynamic timestamp;

  SensorData(
      {required this.sensorId, required this.value, required this.timestamp});
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DatabaseReference _sensorDataRef;
  SensorData? _latestSensorData;

  @override
  void initState() {
    super.initState();
    _sensorDataRef = FirebaseDatabase.instance.reference().child('sensor_data');
    _initSensorDataListener();
  }

  void _initSensorDataListener() {
    _sensorDataRef.orderByKey().limitToLast(1).onChildAdded.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      setState(() {
        if (snapshot.value != null) {
          dynamic value = snapshot.value;
          _latestSensorData = SensorData(
            sensorId: snapshot.key!,
            value: value['value'] ?? 'N/A',
            timestamp: value['timestamp'] ?? 'N/A',
          );
        }
      });
    }, onError: (error) {
      print("Error: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parking System'),
      ),
      body: _latestSensorData == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                ListTile(
                  title: Text('Sensor ID: ${_latestSensorData!.sensorId}'),
                  subtitle: Text('Value: ${_latestSensorData!.value ?? 'N/A'}'),
                  trailing: Text(
                      'Timestamp: ${_latestSensorData!.timestamp ?? 'N/A'}'),
                ),
                Icon(
                  Icons.lightbulb,
                  size: 60,
                  color:
                      _latestSensorData!.value == 1 ? Colors.red : Colors.green,
                ),
              ],
            ),
    );
  }
}
