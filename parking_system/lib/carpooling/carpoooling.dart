import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CarpoolingPage extends StatefulWidget {
  @override
  _CarpoolingPageState createState() => _CarpoolingPageState();
}

class _CarpoolingPageState extends State<CarpoolingPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController riderPhoneController = TextEditingController();
  final TextEditingController rideDetailsController = TextEditingController();
  final TextEditingController startPlaceController = TextEditingController();
  final TextEditingController destinationPlaceController =
      TextEditingController();

  DateTime? _selectedDate;
  int? _selectedHour;
  int? _selectedMinute;
  String? _selectedAmPm;

  final List<int> hours = List.generate(12, (index) => index + 1);
  final List<int> minutes = List.generate(60, (index) => index);
  final List<String> amPm = ['AM', 'PM'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carpooling'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('carpooling').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No carpooling rides available.'));
          }

          final carpools = snapshot.data!.docs;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              initiallyExpanded: true,
              title: Text('Created Carpools'),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: carpools.length,
                  itemBuilder: (context, index) {
                    final carpool = carpools[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(
                          carpool['riderName'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(carpool['rideDetails']),
                            Text('Contact: ${carpool['riderPhone']}'),
                            Text('Start: ${carpool['startPlace']}'),
                            Text('Destination: ${carpool['destinationPlace']}'),
                            Text(
                                'Journey Date: ${carpool['journeyStartDateTime']}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteCarpool(carpool.id),
                            ),
                            IconButton(
                              icon: Icon(Icons.add, color: Colors.green),
                              onPressed: () =>
                                  _requestToJoinCarpool(carpool.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateCarpoolDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  void _showCreateCarpoolDialog() {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String? riderName = currentUser?.displayName;

    if (riderName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: User not logged in')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Create Carpool'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: TextEditingController(text: riderName),
                      decoration: InputDecoration(
                        labelText: 'Rider Name',
                      ),
                      readOnly: true,
                    ),
                    TextField(
                      controller: riderPhoneController,
                      decoration: InputDecoration(
                        labelText: 'Rider Phone',
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    TextField(
                      controller: rideDetailsController,
                      decoration: InputDecoration(
                        labelText: 'Ride Details',
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    TextField(
                      controller: startPlaceController,
                      decoration: InputDecoration(
                        labelText: 'Start Place',
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    TextField(
                      controller: destinationPlaceController,
                      decoration: InputDecoration(
                        labelText: 'Destination Place',
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text("Date: "),
                        SizedBox(width: 10),
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
                                _selectedDate = pickedDate;
                              });
                            }
                          },
                          child: Text(
                            _selectedDate == null
                                ? 'Select Date'
                                : DateFormat('yyyy-MM-dd')
                                    .format(_selectedDate!),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          child: DropdownButtonFormField<int>(
                            isExpanded: true,
                            hint: Text('00'),
                            value: _selectedHour,
                            onChanged: (value) {
                              setState(() {
                                _selectedHour = value;
                              });
                            },
                            items: hours.map((hour) {
                              return DropdownMenuItem<int>(
                                value: hour,
                                child: Center(child: Text(hour.toString())),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 60,
                          child: DropdownButtonFormField<int>(
                            isExpanded: true,
                            hint: Text('00'),
                            value: _selectedMinute,
                            onChanged: (value) {
                              setState(() {
                                _selectedMinute = value;
                              });
                            },
                            items: minutes.map((minute) {
                              return DropdownMenuItem<int>(
                                value: minute,
                                child: Center(
                                    child: Text(
                                        minute.toString().padLeft(2, '0'))),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 80,
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            hint: Text('AM/PM'),
                            value: _selectedAmPm,
                            onChanged: (value) {
                              setState(() {
                                _selectedAmPm = value;
                              });
                            },
                            items: amPm.map((period) {
                              return DropdownMenuItem<String>(
                                value: period,
                                child: Center(child: Text(period)),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (riderPhoneController.text.isEmpty ||
                        rideDetailsController.text.isEmpty ||
                        startPlaceController.text.isEmpty ||
                        destinationPlaceController.text.isEmpty ||
                        _selectedDate == null ||
                        _selectedHour == null ||
                        _selectedMinute == null ||
                        _selectedAmPm == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill in all fields')),
                      );
                      return;
                    }

                    _createCarpool(riderName);
                    Navigator.of(context).pop();
                  },
                  child: Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _createCarpool(String riderName) async {
    DateTime journeyStartDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedAmPm == 'PM' ? _selectedHour! + 12 : _selectedHour!,
      _selectedMinute!,
    );

    await _firestore.collection('carpooling').add({
      'riderName': riderName,
      'riderPhone': riderPhoneController.text,
      'rideDetails': rideDetailsController.text,
      'startPlace': startPlaceController.text,
      'destinationPlace': destinationPlaceController.text,
      'journeyStartDateTime':
          DateFormat('yyyy-MM-dd – kk:mm').format(journeyStartDateTime),
      'requests': [],
      'createdBy': FirebaseAuth.instance.currentUser!.uid,
    });

    riderPhoneController.clear();
    rideDetailsController.clear();
    startPlaceController.clear();
    destinationPlaceController.clear();
    setState(() {
      _selectedDate = null;
      _selectedHour = null;
      _selectedMinute = null;
      _selectedAmPm = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Carpool created successfully')),
    );
  }

  void _deleteCarpool(String id) async {
    await _firestore.collection('carpooling').doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Carpool deleted successfully')),
    );
  }

  void _requestToJoinCarpool(String id) async {
    final doc = await _firestore.collection('carpooling').doc(id).get();
    List requests = doc['requests'] as List? ?? [];
    requests.add(FirebaseAuth.instance.currentUser!.displayName);

    await _firestore
        .collection('carpooling')
        .doc(id)
        .update({'requests': requests});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Request to join carpool sent')),
    );
  }
}
