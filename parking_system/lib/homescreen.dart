import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_system/carpooling/carpooling.dart';
import 'package:parking_system/parking_slots.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => Get.to(ParkingHomePage()),
                child: Text('Parking Slots'),
              ),
              ElevatedButton(
                onPressed: () => Get.to(CarpoolingPage()),
                child: Text('Carpooling Screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
