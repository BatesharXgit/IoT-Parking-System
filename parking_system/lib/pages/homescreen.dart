import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_system/carpooling/carpooling.dart';
import 'package:parking_system/controller/theme_controller.dart';
import 'package:parking_system/pages/about_us.dart';
import 'package:parking_system/pages/faq.dart';
import 'package:parking_system/notifications.dart';
import 'package:parking_system/controller/parking_controller.dart';
import 'package:parking_system/pages/parking_home.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.put(ThemeController());
    ParkingController parkingController = Get.put(ParkingController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "DASHBOARD",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          Obx(
            () => IconButton(
              onPressed: () {
                themeController.changeTheme();
              },
              icon: themeController.isDark.value
                  ? Icon(
                      Icons.wb_sunny,
                      color: Colors.white,
                    )
                  : Icon(
                      Icons.nightlight_round,
                      color: Colors.white,
                    ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "QuickPark",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              "Welcome to Car Parking System you can book your parking slot from any where with you phone",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      Get.to(ParkingHomePage());
                      // Get.to(GoogleMapPage());
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      height: 200,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_parking,
                            size: 40,
                          ),
                          SizedBox(height: 40),
                          Text(
                            "View Parking Spots",
                            style: Theme.of(context).textTheme.headlineMedium,
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      Get.to(CarpoolingPage());
                      // Get.to(GoogleMapPage());
                    },
                    child: Container(
                      height: 200,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.car_rental,
                            size: 40,
                          ),
                          SizedBox(height: 40),
                          Text(
                            "Carpool",
                            style: Theme.of(context).textTheme.headlineMedium,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 14,
            ),
            InkWell(
              onTap: () {
                Get.to(NotificationPage());
              },
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications,
                      size: 40,
                    ),
                    SizedBox(width: 30),
                    Text(
                      "View Notification",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 14),
            InkWell(
              onTap: () {
                // Get.to(ParkingHomePage());
                Get.to(AboutUsPage());
              },
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info,
                      size: 40,
                    ),
                    SizedBox(width: 30),
                    Expanded(
                      child: Text(
                        "About US",
                        style: Theme.of(context).textTheme.headlineMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 14),
            InkWell(
              onTap: () {
                Get.to(FAQPage());
                // Get.to(GoogleMapPage());
              },
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.question_answer,
                      size: 40,
                    ),
                    SizedBox(width: 30),
                    Text(
                      "FAQ",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
