import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parking_system/car_model.dart';
import 'package:parking_system/config.dart';

class ParkingController extends GetxController {
  RxList<CarModel> parkingSlotList = <CarModel>[].obs;
  TextEditingController name = TextEditingController();
  TextEditingController vehicalNumber = TextEditingController();
  RxDouble parkingTimeInMin = 10.0.obs;
  RxInt parkingAmount = 0.obs;
  RxString slotName = "".obs;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  var slot1 = Slot(booked: false, isOccupied: false, parkingHours: "0").obs;
  var slot2 = Slot(booked: false, isOccupied: false, parkingHours: "0").obs;
  var slot3 = Slot(booked: false, isOccupied: false, parkingHours: "0").obs;

  var parkingStartTime = DateTime.now().obs;
  var parkingEndTime = DateTime.now().obs;

  String formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  void calculateAmount() {
    final duration =
        parkingEndTime.value.difference(parkingStartTime.value).inMinutes;
    if (duration <= 30) {
      parkingAmount.value = 30;
    } else {
      parkingAmount.value = 60;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _listenToSlotChanges();
  }

  void _listenToSlotChanges() {
    _database.child('sensor_data').onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        slot1.update((val) {
          val?.booked = data["Slot 1"]["value"] != 1;
          val?.isOccupied = data["Slot 1"]["isOccupied"] == 0;
          val?.parkingHours = data["Slot 1"]['timestamp'].toString() ?? "N/A";
        });
        slot2.update((val) {
          val?.booked = data["Slot 2"]["value"] != 1;
          val?.isOccupied = data["Slot 2"]["isOccupied"] == 0;
          val?.parkingHours = "N/A"; // Update with actual data if available
        });
        slot3.update((val) {
          val?.booked = data["Slot 3"]["value"] != 1;
          val?.isOccupied = data["Slot 3"]["isOccupied"] == 0;
          val?.parkingHours = "N/A"; // Update with actual data if available
        });
      }
    });
  }

  void bookSlot(String slotId) async {
    await _database.child('booking_status').update({
      'Slot $slotId': {
        'booked': 1,
        'parkingTime': parkingTimeInMin.value,
      }
    });
    BookedPopup();

    // Future.delayed(const Duration(seconds: 60), () {
    //   cancelBooking(slotId);
    // });
  }

  void cancelBooking(String slotId) async {
    try {
      await _database.child('booking_status').update({
        'Slot $slotId': {
          'booked': 0,
          'parkingTime': 0,
        }
      });

      // Show a popup to confirm the cancellation
      Get.defaultDialog(
        title: "Booking Cancelled",
        content: Text("The booking for Slot $slotId has been cancelled."),
        onConfirm: () {
          Get.back();
        },
        textConfirm: "OK",
      );
    } catch (e) {
      // Handle error
      Get.defaultDialog(
        title: "Error",
        content: Text(
            "Failed to cancel the booking for Slot $slotId. Please try again."),
        onConfirm: () {
          Get.back();
        },
        textConfirm: "OK",
      );
    }
  }

  Future<dynamic> BookedPopup() {
    return Get.defaultDialog(
      barrierDismissible: false,
      title: "SLOT BOOKED",
      titleStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: darkBlueColor,
      ),
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Your Slot Booked",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: darkBlueColor,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person),
              SizedBox(width: 5),
              Text(
                "Name : ",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              SizedBox(width: 20),
              Text(
                name.text,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.car_rental),
              SizedBox(width: 5),
              Text(
                "Vehical No  : ",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              SizedBox(width: 20),
              Text(
                vehicalNumber.text,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.watch_later_outlined),
              SizedBox(width: 5),
              Text(
                "Parking time : ",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              SizedBox(width: 20),
              Text(
                parkingTimeInMin.value.toString(),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.solar_power_outlined),
              SizedBox(width: 5),
              Text(
                "Parking Slot : ",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              SizedBox(width: 20),
              Text(
                "A-${slotName.value.toString()}",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.currency_rupee,
                size: 40,
                color: darkBlueColor,
              ),
              Text(
                parkingAmount.value.toString(),
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: darkBlueColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: Text("Close"),
          )
        ],
      ),
    );
  }
}

class Slot {
  bool booked;
  bool isOccupied;

  String parkingHours;

  Slot(
      {required this.booked,
      required this.isOccupied,
      required this.parkingHours});
}
