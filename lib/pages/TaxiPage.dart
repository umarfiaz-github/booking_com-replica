import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TaxiPage extends StatefulWidget {
  @override
  _TaxiPageState createState() => _TaxiPageState();
}

class _TaxiPageState extends State<TaxiPage> {
  String? pickUpLocation;
  String? dropOffLocation;
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Pick-up location field
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_on),
                  hintText: 'Pick-up location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    pickUpLocation = value;
                  });
                },
              ),
              SizedBox(height: 10),

              // Drop-off location field
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_on),
                  hintText: 'Drop-off location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    dropOffLocation = value;
                  });
                },
              ),
              SizedBox(height: 10),

              // Date selection field
              TextField(
                readOnly: true,
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2025),
                  );
                  if (date != null) {
                    setState(() {
                      selectedDate = date;
                    });
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today),
                  hintText: selectedDate == null
                      ? 'Select date'
                      : selectedDate!.toString().split(' ')[0],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  _performSearch();
                },
                child: Text('Search'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), // Full-width button
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _performSearch() async {
    if (pickUpLocation == null ||
        dropOffLocation == null ||
        selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      return;
    }

    final bookingApiKey = dotenv.env['Booking_Api_Key'];

    final url = Uri.parse('https://api.example.com/search_taxis');
    final response = await http.get(url.replace(queryParameters: {
      'api_key': bookingApiKey,
      'pick_up_location': pickUpLocation,
      'drop_off_location': dropOffLocation,
      'date': selectedDate!.toString().split(' ')[0],
    }));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Search successful'),
        ),
      );
      // Navigate to results page or display data
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load data'),
        ),
      );
    }
  }
}
