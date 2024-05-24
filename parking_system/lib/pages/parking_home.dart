import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_system/pages/booking_page.dart';
import 'package:parking_system/config.dart';
import 'package:parking_system/controller/parking_controller.dart';

class ParkingHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ParkingController parkingController = Get.put(ParkingController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlueColor,
        centerTitle: true,
        title: Text(
          "Smart Parking System",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "Parking Slots",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [Text("ENTRY"), Icon(Icons.keyboard_arrow_down)],
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => ParkingSlot(
                        controller: parkingController,
                        isBooked: parkingController.slot1.value.booked,
                        isOccupied: parkingController.slot1.value.isOccupied,
                        slotName: "A-1",
                        slotId: "1",
                        time: parkingController.slot1.value.parkingHours,
                        onBookNow: () =>
                            Get.to(BookingPage(slotId: "A-1", slotName: "1")),
                        cancelBooking: () => parkingController.bookSlot("1"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: VerticalDivider(
                      color: Theme.of(context).colorScheme.onBackground,
                      thickness: 6,
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => ParkingSlot(
                        controller: parkingController,
                        isBooked: parkingController.slot3.value.booked,
                        isOccupied: parkingController.slot3.value.isOccupied,
                        slotName: "A-3",
                        slotId: "3",
                        time: parkingController.slot3.value.parkingHours,
                        onBookNow: () =>
                            Get.to(BookingPage(slotId: "A-3", slotName: "3")),
                        cancelBooking: () => parkingController.bookSlot("3"),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => ParkingSlot(
                        controller: parkingController,
                        isBooked: parkingController.slot2.value.booked,
                        isOccupied: parkingController.slot2.value.isOccupied,
                        slotName: "A-2",
                        slotId: "2",
                        time: parkingController.slot2.value.parkingHours,
                        onBookNow: () =>
                            Get.to(BookingPage(slotId: "A-2", slotName: "2")),
                        cancelBooking: () => parkingController.bookSlot("2"),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [Text("EXIT"), Icon(Icons.keyboard_arrow_down)],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ParkingSlot extends StatelessWidget {
  final bool? isOccupied;
  final bool? isBooked;
  final String? slotName;
  final String slotId;
  final String time;
  final VoidCallback cancelBooking;
  final VoidCallback onBookNow;
  final ParkingController controller;

  const ParkingSlot({
    Key? key,
    this.isOccupied,
    this.isBooked,
    this.slotName,
    this.slotId = "0.0",
    required this.time,
    required this.cancelBooking,
    required this.onBookNow,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("isOccupied${isOccupied}");
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 180,
        height: 200,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // time == ""
                //     ? SizedBox(width: 1)
                //     : Container(
                //         child: Text(time),
                //       ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                  margin: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    slotName.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  child: Text(""),
                )
              ],
            ),
            SizedBox(height: 40),
            if (isBooked == true && isOccupied == true)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Occupied",
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            else if (isBooked == true)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Booked",
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => Get.to(
                          BookingPage(
                            slotId: slotId,
                            slotName: slotName.toString(),
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 30,
                          ),
                          decoration: BoxDecoration(
                            color: darkBlueColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "Book",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: 1,
                      // ),
                      // InkWell(
                      //   onTap: () => controller.cancelBooking(slotId),
                      //   child: Container(
                      //     padding: EdgeInsets.symmetric(
                      //       vertical: 7,
                      //       horizontal: 30,
                      //     ),
                      //     decoration: BoxDecoration(
                      //       color: darkBlueColor,
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     child: const Text(
                      //       "Cancel",
                      //       style: TextStyle(
                      //         color: Colors.white,
                      //         fontSize: 15,
                      //         fontWeight: FontWeight.w500,
                      //         letterSpacing: 1.2,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
