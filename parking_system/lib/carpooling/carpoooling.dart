import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CarpoolingPage extends StatefulWidget {
  const CarpoolingPage({super.key});

  @override
  State<CarpoolingPage> createState() => _CarpoolingPageState();
}

class _CarpoolingPageState extends State<CarpoolingPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Carpooling'),
      ),
      body: CarpoolList(firestore: _firestore),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCreateCarpoolDialog(context, _firestore),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CarpoolList extends StatelessWidget {
  final FirebaseFirestore firestore;

  const CarpoolList({super.key, required this.firestore});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        createdCarpoolsExtensionTile(),
        const SizedBox(height: 10),
        otherCarpools(),
      ],
    );
  }

  Widget createdCarpoolsExtensionTile() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('carpooling')
          .where('createdByUserUID',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .orderBy('createdOn', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return SingleChildScrollView(
            child: ExpansionTile(
              backgroundColor: Colors.blue.withOpacity(0.4),
              // initiallyExpanded: true,
              collapsedBackgroundColor: Colors.blue.withOpacity(0.2),
              title: const Text('Created Carpools'),
              children: const [],
            ),
          );
        }

        final carpools = snapshot.data!.docs;
        return SingleChildScrollView(
          child: ExpansionTile(
            backgroundColor: Colors.blue.withOpacity(0.4),
            // initiallyExpanded: true,
            collapsedBackgroundColor: Colors.blue.withOpacity(0.2),
            title: const Text('Created Carpools'),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: carpools.length,
                itemBuilder: (context, index) {
                  final carpool = carpools[index];
                  return CarpoolCard(
                    carpool: carpool,
                    currentUserUID: FirebaseAuth.instance.currentUser!.uid,
                    onDelete: () =>
                        _deleteCarpool(carpool.id, firestore, context),
                    onJoin: () =>
                        _requestToJoinCarpool(carpool.id, firestore, context),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget otherCarpools() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('carpooling')
          .where('createdByUserUID',
              isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .orderBy('createdOn', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return SingleChildScrollView(
            child: ExpansionTile(
              backgroundColor: Colors.blue.withOpacity(0.4),
              // initiallyExpanded: true,
              collapsedBackgroundColor: Colors.blue.withOpacity(0.2),
              title: const Text('Other Carpools'),
              children: const [],
            ),
          );
        }

        final carpools = snapshot.data!.docs;
        return SingleChildScrollView(
          child: ExpansionTile(
            backgroundColor: Colors.blue.withOpacity(0.4),
            // initiallyExpanded: true,
            collapsedBackgroundColor: Colors.blue.withOpacity(0.2),
            title: const Text('Other Carpools'),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: carpools.length,
                itemBuilder: (context, index) {
                  final carpool = carpools[index];
                  return CarpoolCard(
                    carpool: carpool,
                    currentUserUID: FirebaseAuth.instance.currentUser!.uid,
                    onDelete: () =>
                        _deleteCarpool(carpool.id, firestore, context),
                    onJoin: () =>
                        _requestToJoinCarpool(carpool.id, firestore, context),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteCarpool(
      String id, FirebaseFirestore firestore, BuildContext context) async {
    await firestore.collection('carpooling').doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Carpool deleted successfully')),
    );
  }

  void _requestToJoinCarpool(
      String id, FirebaseFirestore firestore, BuildContext context) async {
    final doc = await firestore.collection('carpooling').doc(id).get();
    List requests = doc['requests'] as List? ?? [];
    requests.add(FirebaseAuth.instance.currentUser!.displayName);

    await firestore
        .collection('carpooling')
        .doc(id)
        .update({'requests': requests});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request to join carpool sent')),
    );
  }
}

// class CarpoolCard extends StatelessWidget {
//   final QueryDocumentSnapshot carpool;
//   final VoidCallback onDelete;
//   final VoidCallback onJoin;
//   final String currentUserUID;

//   const CarpoolCard({
//     super.key,
//     required this.carpool,
//     required this.onDelete,
//     required this.onJoin,
//     required this.currentUserUID,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shadowColor: Colors.blue,
//       elevation: 6,
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//       child: ListTile(
//         title: Text(
//           carpool['riderName'],
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Details: ${carpool['rideDetails']}'),
//             Text('Contact: ${carpool['riderPhone']}'),
//             Text('Start: ${carpool['startPlace']}'),
//             Text('Destination: ${carpool['destinationPlace']}'),
//             Text('Journey Date: ${carpool['journeyStartDateTime']}'),
//           ],
//         ),
//         trailing: (currentUserUID == carpool['createdByUserUID'])
//             ? IconButton(
//                 icon: const Icon(Icons.delete, color: Colors.red),
//                 onPressed: onDelete,
//               )
//             : IconButton(
//                 icon: const Icon(Icons.add, color: Colors.green),
//                 onPressed: onJoin,
//               ),
//       ),
//     );
//   }
// }

class CarpoolCard extends StatelessWidget {
  final QueryDocumentSnapshot carpool;
  final VoidCallback onDelete;
  final VoidCallback onJoin;
  final String currentUserUID;

  const CarpoolCard({
    super.key,
    required this.carpool,
    required this.onDelete,
    required this.onJoin,
    required this.currentUserUID,
  });

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Carpool Details'),
          content: currentUserUID == carpool['createdByUserUID']
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: (carpool['requests'] as List<dynamic>)
                      .map((request) => Text(
                          'Name: ${request['name']}, Phone: ${request['phone']}'))
                      .toList(),
                )
              : const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Phone Number'),
                    ),
                  ],
                ),
          actions: <Widget>[
            currentUserUID == carpool['createdByUserUID']
                ? TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  )
                : TextButton(
                    onPressed: () {
                      // handle the join logic here
                      Navigator.of(context).pop();
                    },
                    child: const Text('Join'),
                  ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDialog(context),
      child: Card(
        shadowColor: Colors.blue,
        elevation: 6,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: ListTile(
          title: Text(
            carpool['riderName'],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Details: ${carpool['rideDetails']}'),
              Text('Contact: ${carpool['riderPhone']}'),
              Text('Start: ${carpool['startPlace']}'),
              Text('Destination: ${carpool['destinationPlace']}'),
              Text('Journey Date: ${carpool['journeyStartDateTime']}'),
            ],
          ),
          trailing: (currentUserUID == carpool['createdByUserUID'])
              ? IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                )
              : IconButton(
                  icon: const Icon(Icons.add, color: Colors.green),
                  onPressed: onJoin,
                ),
        ),
      ),
    );
  }
}

void showCreateCarpoolDialog(
    BuildContext context, FirebaseFirestore firestore) {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final String? riderName = currentUser?.displayName;
  final TextEditingController riderPhoneController = TextEditingController();
  final TextEditingController rideDetailsController = TextEditingController();
  final TextEditingController startPlaceController = TextEditingController();
  final TextEditingController destinationPlaceController =
      TextEditingController();
  DateTime? selectedDate;
  int? selectedHour;
  int? selectedMinute;
  String? selectedAmPm;
  final List<int> hours = List.generate(12, (index) => index + 1);
  final List<int> minutes = List.generate(60, (index) => index);
  final List<String> amPm = ['AM', 'PM'];

  void createCarpool(
    FirebaseFirestore firestore,
    String riderName,
    String riderPhone,
    String rideDetails,
    String startPlace,
    String destinationPlace,
    DateTime selectedDate,
    int selectedHour,
    int selectedMinute,
    String selectedAmPm,
  ) async {
    DateTime journeyStartDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedAmPm == 'PM' ? selectedHour + 12 : selectedHour,
      selectedMinute,
    );

    await firestore.collection('carpooling').add({
      'riderName': riderName,
      'riderPhone': riderPhone,
      'rideDetails': rideDetails,
      'startPlace': startPlace,
      'destinationPlace': destinationPlace,
      'journeyStartDateTime':
          DateFormat('yyyy-MM-dd – kk:mm').format(journeyStartDateTime),
      'requests': [],
      'createdByUserUID': FirebaseAuth.instance.currentUser!.uid,
      'createdOn': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Carpool created successfully')),
    );
  }

  if (riderName == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error: User not logged in')),
    );
    return;
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Create Carpool'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: TextEditingController(text: riderName),
                    decoration: const InputDecoration(
                      labelText: 'Rider Name',
                    ),
                    readOnly: true,
                  ),
                  TextField(
                    controller: riderPhoneController,
                    decoration: const InputDecoration(
                      labelText: 'Rider Phone',
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  TextField(
                    controller: rideDetailsController,
                    decoration: const InputDecoration(
                      labelText: 'Ride Details',
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  TextField(
                    controller: startPlaceController,
                    decoration: const InputDecoration(
                      labelText: 'Start Place',
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  TextField(
                    controller: destinationPlaceController,
                    decoration: const InputDecoration(
                      labelText: 'Destination Place',
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text("Date: "),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                        child: Text(
                          selectedDate == null
                              ? 'Select Date'
                              : DateFormat('yyyy-MM-dd').format(selectedDate!),
                        ),
                      ),
                    ],
                  ),
                  TimePicker(
                    hours: hours,
                    minutes: minutes,
                    amPm: amPm,
                    selectedHour: selectedHour,
                    selectedMinute: selectedMinute,
                    selectedAmPm: selectedAmPm,
                    onHourChanged: (value) {
                      setState(() {
                        selectedHour = value;
                      });
                    },
                    onMinuteChanged: (value) {
                      setState(() {
                        selectedMinute = value;
                      });
                    },
                    onAmPmChanged: (value) {
                      setState(() {
                        selectedAmPm = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (riderPhoneController.text.isEmpty ||
                      rideDetailsController.text.isEmpty ||
                      startPlaceController.text.isEmpty ||
                      destinationPlaceController.text.isEmpty ||
                      selectedDate == null ||
                      selectedHour == null ||
                      selectedMinute == null ||
                      selectedAmPm == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please fill in all fields')),
                    );
                    return;
                  }

                  createCarpool(
                    firestore,
                    riderName,
                    riderPhoneController.text,
                    rideDetailsController.text,
                    startPlaceController.text,
                    destinationPlaceController.text,
                    selectedDate!,
                    selectedHour!,
                    selectedMinute!,
                    selectedAmPm!,
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Create'),
              ),
            ],
          );
        },
      );
    },
  );
}

class TimePicker extends StatelessWidget {
  final List<int> hours;
  final List<int> minutes;
  final List<String> amPm;
  final int? selectedHour;
  final int? selectedMinute;
  final String? selectedAmPm;
  final ValueChanged<int?> onHourChanged;
  final ValueChanged<int?> onMinuteChanged;
  final ValueChanged<String?> onAmPmChanged;

  const TimePicker({
    super.key,
    required this.hours,
    required this.minutes,
    required this.amPm,
    required this.selectedHour,
    required this.selectedMinute,
    required this.selectedAmPm,
    required this.onHourChanged,
    required this.onMinuteChanged,
    required this.onAmPmChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 60,
          child: DropdownButtonFormField<int>(
            isExpanded: true,
            hint: const Text('00'),
            value: selectedHour,
            onChanged: onHourChanged,
            items: hours.map((hour) {
              return DropdownMenuItem<int>(
                value: hour,
                child: Center(child: Text(hour.toString())),
              );
            }).toList(),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 60,
          child: DropdownButtonFormField<int>(
            isExpanded: true,
            hint: const Text('00'),
            value: selectedMinute,
            onChanged: onMinuteChanged,
            items: minutes.map((minute) {
              return DropdownMenuItem<int>(
                value: minute,
                child: Center(child: Text(minute.toString().padLeft(2, '0'))),
              );
            }).toList(),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 80,
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            hint: const Text('AM/PM'),
            value: selectedAmPm,
            onChanged: onAmPmChanged,
            items: amPm.map((period) {
              return DropdownMenuItem<String>(
                value: period,
                child: Center(child: Text(period)),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
