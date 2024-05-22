import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_system/config.dart';
import 'package:parking_system/parking_controller.dart';

class BookingPage extends StatelessWidget {
  final String slotName;
  final String slotId;
  const BookingPage({super.key, required this.slotId, required this.slotName});

  @override
  Widget build(BuildContext context) {
    ParkingController parkingController = Get.put(ParkingController());
    // WithoutFirebase withoutFirebase = Get.put(WithoutFirebase());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlueColor,
        title: const Text(
          "Book Slot",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
              ),
              SizedBox(height: 20),
              const Row(
                children: [
                  Text(
                    "Enter your name ",
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: parkingController.name,
                      decoration: const InputDecoration(
                        fillColor: lightBg,
                        filled: true,
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.person,
                          color: darkBlueColor,
                        ),
                        hintText: "Name",
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 30),
              const Row(
                children: [
                  Text(
                    "Enter Vehical Number ",
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: parkingController.vehicalNumber,
                      decoration: const InputDecoration(
                        fillColor: lightBg,
                        filled: true,
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.car_rental,
                          color: darkBlueColor,
                        ),
                        hintText: "00 00 0 0000",
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              const Row(
                children: [
                  Text(
                    "Choose Slot Time (in Minuits)",
                  )
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => ListTile(
                          title: Text(
                            "Start Time:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            parkingController.formatDateTime(
                                parkingController.parkingStartTime.value),
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate:
                                    parkingController.parkingStartTime.value,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      parkingController.parkingStartTime.value),
                                );
                                if (pickedTime != null) {
                                  parkingController.parkingStartTime.value =
                                      DateTime(
                                    pickedDate.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                    pickedTime.hour,
                                    pickedTime.minute,
                                  );
                                  parkingController.calculateAmount();
                                }
                              }
                            },
                            child: Text("Select Start Time"),
                          ),
                        )),
                    SizedBox(height: 16),
                    Obx(() => ListTile(
                          title: Text(
                            "End Time:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            parkingController.formatDateTime(
                                parkingController.parkingEndTime.value),
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate:
                                    parkingController.parkingEndTime.value,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      parkingController.parkingEndTime.value),
                                );
                                if (pickedTime != null) {
                                  parkingController.parkingEndTime.value =
                                      DateTime(
                                    pickedDate.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                    pickedTime.hour,
                                    pickedTime.minute,
                                  );
                                  parkingController.calculateAmount();
                                }
                              }
                            },
                            child: Text("Select End Time"),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Your Slot Name",
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100,
                    height: 80,
                    decoration: BoxDecoration(
                      color: darkBlueColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        slotName,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Text("Amount to Be Pay"),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.currency_rupee,
                            size: 30,
                            color: darkBlueColor,
                          ),
                          Obx(
                            () => Text(
                              "${parkingController.parkingAmount.value}",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                                color: darkBlueColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      parkingController.BookedPopup();
                      parkingController.bookSlot(slotId);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                      decoration: BoxDecoration(
                        color: darkBlueColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Book Now",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
