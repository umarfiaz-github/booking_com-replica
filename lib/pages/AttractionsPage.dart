import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AttractionsPage extends StatefulWidget {
  @override
  _AttractionsPageState createState() => _AttractionsPageState();
}

class _AttractionsPageState extends State<AttractionsPage> {
  String? destination;
  DateTimeRange? selectedDates;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Destination field
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_on),
                  hintText: 'Enter your destination',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    destination = value;
                  });
                },
              ),
              SizedBox(height: 10),

              // Date selection field
              TextField(
                readOnly: true,
                onTap: () async {
                  DateTimeRange? dates = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2025),
                  );
                  if (dates != null) {
                    setState(() {
                      selectedDates = dates;
                    });
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today),
                  hintText: selectedDates == null
                      ? 'Select dates'
                      : '${selectedDates!.start.toString().split(' ')[0]} - ${selectedDates!.end.toString().split(' ')[0]}',
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
    if (destination == null || selectedDates == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      return;
    }

    final bookingApiKey = dotenv.env['Booking_Api_Key'];

    final url = Uri.parse('https://api.example.com/search_attractions');
    final response = await http.get(url.replace(queryParameters: {
      'api_key': bookingApiKey,
      'destination': destination,
      'start_date': selectedDates!.start.toString().split(' ')[0],
      'end_date': selectedDates!.end.toString().split(' ')[0],
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
