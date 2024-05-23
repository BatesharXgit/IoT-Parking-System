import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:parking_system/authentication/auth_path.dart';
import 'package:parking_system/firebase_options.dart';
import 'package:parking_system/homescreen.dart';
import 'package:parking_system/parking_slots.dart';

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
    return GetMaterialApp(
      title: 'Parking System',
      home: AuthPage(),
    );
  }
}
