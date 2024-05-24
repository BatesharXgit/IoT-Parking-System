import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                  child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  height: 140,
                  'assets/parking.png',
                  fit: BoxFit.contain,
                ),
              )),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'QuickPark',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      // color: Colors.teal,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Our Mission',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    // color: Colors.teal,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'At Smart Park, our mission is to revolutionize the way you find and manage parking. With our cutting-edge technology, we aim to make parking easier, faster, and more efficient for everyone.',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Our Vision',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    // color: Colors.teal,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'We envision a future where parking is no longer a hassle. Our smart parking solutions will help reduce traffic congestion, save time, and improve the overall urban living experience.',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AboutUsPage(),
  ));
}
