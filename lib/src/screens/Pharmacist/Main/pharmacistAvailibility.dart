import 'package:flutter/material.dart';

class PharmacistAvailability extends StatefulWidget {
  PharmacistAvailability({Key? key}) : super(key: key);

  @override
  _PharmacistAvailabilityState createState() => _PharmacistAvailabilityState();
}

class _PharmacistAvailabilityState extends State<PharmacistAvailability> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 12,
        title: Text(
          "Availability",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 22),
        ),
        backgroundColor: Color(0xFFF6F6F6),
      ),
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}
