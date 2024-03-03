import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:parking_system/firebase_options.dart';

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
    return MaterialApp(
      title: 'Parking System',
      home: SensorDataScreen(),
    );
  }
}

class SensorDataScreen extends StatefulWidget {
  const SensorDataScreen({super.key});

  @override
  _SensorDataScreenState createState() => _SensorDataScreenState();
}

class _SensorDataScreenState extends State<SensorDataScreen> {
  late DatabaseReference _sensorDataRef;
  late List<Map<String, dynamic>> _sensorDataList;

  @override
  void initState() {
    super.initState();
    _sensorDataRef = FirebaseDatabase.instance.reference().child('sensor_data');
    _sensorDataList = [];
    _initSensorDataListener();
  }

  void _initSensorDataListener() {
    _sensorDataRef.onValue.listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        _sensorDataList.clear();
        values.forEach((key, value) {
          _sensorDataList.add({
            'sensor_id': key,
            'value': value['value'],
            'timestamp': value['timestamp'],
          });
        });
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parking System'),
      ),
      body: ListView.builder(
        itemCount: _sensorDataList.length,
        itemBuilder: (context, index) {
          var data = _sensorDataList[index];
          return ListTile(
            title: Text('Sensor ID: ${data['sensor_id']}'),
            subtitle: Text('Value: ${data['value']}'),
            trailing: Text('Timestamp: ${data['timestamp']}'),
          );
        },
      ),
    );
  }
}
