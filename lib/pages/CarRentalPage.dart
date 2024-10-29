import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_screen.dart';
import 'car_rental_results_page.dart';

class CarRentalPage extends StatefulWidget {
  @override
  _CarRentalPageState createState() => _CarRentalPageState();
}

class _CarRentalPageState extends State<CarRentalPage> {
  String? pickUpLocation;
  double? pickUpLatitude;
  double? pickUpLongitude;
  DateTime? pickUpDate;
  TimeOfDay? pickUpTime;
  DateTime? dropOffDate;
  TimeOfDay? dropOffTime;
  String? driverAge;

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
                readOnly: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_on),
                  hintText: pickUpLocation ?? 'Pick-up location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onTap: () async {
                  final selectedLocation = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapScreen(
                        onLocationSelected: (LatLng location) async {
                          return 'Lat: ${location.latitude}, Lng: ${location.longitude}';
                        },
                      ),
                    ),
                  );
                  if (selectedLocation != null) {
                    setState(() {
                      pickUpLatitude = double.parse(selectedLocation.split(',')[0].split(':')[1].trim());
                      pickUpLongitude = double.parse(selectedLocation.split(',')[1].split(':')[1].trim());
                      pickUpLocation = selectedLocation;
                    });
                  }
                },
              ),
              SizedBox(height: 10),

              // Pick-up date field
              TextField(
                readOnly: true,
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2026),
                  );
                  if (date != null) {
                    setState(() {
                      pickUpDate = date;
                    });
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today),
                  hintText: pickUpDate == null
                      ? 'Pick-up date'
                      : pickUpDate!.toString().split(' ')[0],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Pick-up time field
              TextField(
                readOnly: true,
                onTap: () async {
                  TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() {
                      pickUpTime = time;
                    });
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.access_time),
                  hintText: pickUpTime == null
                      ? 'Pick-up time'
                      : pickUpTime!.format(context),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Drop-off date field
              TextField(
                readOnly: true,
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2026),
                  );
                  if (date != null) {
                    setState(() {
                      dropOffDate = date;
                    });
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today),
                  hintText: dropOffDate == null
                      ? 'Drop-off date'
                      : dropOffDate!.toString().split(' ')[0],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Drop-off time field
              TextField(
                readOnly: true,
                onTap: () async {
                  TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() {
                      dropOffTime = time;
                    });
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.access_time),
                  hintText: dropOffTime == null
                      ? 'Drop-off time'
                      : dropOffTime!.format(context),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Driver's age field
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: "Driver's age",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    driverAge = value;
                  });
                },
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: _performSearch,
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
    if (pickUpLatitude == null ||
        pickUpLongitude == null ||
        pickUpDate == null ||
        pickUpTime == null ||
        dropOffDate == null ||
        dropOffTime == null ||
        driverAge == null ||
        driverAge!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      return;
    }

    final bookingApiKey = dotenv.env['BOOKING_API_KEY'];

    final url = Uri.parse(
      'https://booking-com15.p.rapidapi.com/api/v1/cars/searchCarRentals',
    ).replace(queryParameters: {
      'pick_up_latitude': pickUpLatitude.toString(),
      'pick_up_longitude': pickUpLongitude.toString(),
      'drop_off_latitude': pickUpLatitude.toString(),
      'drop_off_longitude': pickUpLongitude.toString(),
      'pick_up_time': '${pickUpDate!.toString().split(' ')[0]} ${pickUpTime!.format(context)}',
      'drop_off_time': '${dropOffDate!.toString().split(' ')[0]} ${dropOffTime!.format(context)}',
      'driver_age': driverAge!,
      'currency_code': 'USD',
    });

    final response = await http.get(
      url,
      headers: {
        'x-rapidapi-host': 'booking-com15.p.rapidapi.com',
        'x-rapidapi-key': bookingApiKey!,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final carRentals = data['results'] ?? [];

      if (carRentals.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarRentalResultsPage(carRentals: carRentals),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No cars available for the selected criteria'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load data'),
        ),
      );
    }
  }
}
