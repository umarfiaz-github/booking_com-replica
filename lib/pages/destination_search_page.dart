import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DestinationSearchPage extends StatefulWidget {
  final void Function(String, String) onDestinationSelected;

  DestinationSearchPage({required this.onDestinationSelected});

  @override
  _DestinationSearchPageState createState() => _DestinationSearchPageState();
}

class _DestinationSearchPageState extends State<DestinationSearchPage> {
  List<dynamic> hotels = [];
  bool isLoading = false;

  Future<void> _searchHotels(String query) async {
    if (query.isEmpty) {
      setState(() {
        hotels = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final apiKey = dotenv.env['BOOKING_API_KEY'];
      final destId = 'city'; // Example placeholder, you need to get the correct destination ID
      final arrivalDate = '2023-09-20'; // Example placeholder, set the correct arrival date
      final departureDate = '2023-09-25'; // Example placeholder, set the correct departure date

      final uri = Uri.parse(
        'https://booking-com15.p.rapidapi.com/api/v1/hotels/searchHotels'
            '?dest_id=$destId&search_type=CITY&adults=1&children_age=0%2C17&room_qty=1'
            '&page_number=1&units=metric&temperature_unit=c&languagecode=en-us&currency_code=AED'
            '&arrival_date=$arrivalDate&departure_date=$departureDate',
      );

      final hotelsResponse = await http.get(
        uri,
        headers: {
          'x-rapidapi-host': 'booking-com15.p.rapidapi.com',
          'x-rapidapi-key': apiKey ?? '',
        },
      );

      print('Hotels Response Status: ${hotelsResponse.statusCode}');
      print('Hotels Response Body: ${hotelsResponse.body}');

      if (hotelsResponse.statusCode == 200) {
        final hotelsData = json.decode(hotelsResponse.body);

        if (hotelsData['status'] == true && hotelsData.containsKey('result')) {
          setState(() {
            hotels = hotelsData['result'];
            isLoading = false;
          });
        } else {
          throw Exception(hotelsData['message'] ?? 'Failed to load hotels');
        }
      } else {
        throw Exception('Failed to load hotels');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: ${e.toString()}')),
      );
      print('Error: $e'); // Logging for debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Destination'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Stack(
              children: [
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Enter destination',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                  onChanged: (value) {
                    _searchHotels(value);
                  },
                ),
                if (isLoading)
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: hotels.length,
              itemBuilder: (context, index) {
                final hotel = hotels[index];
                return ListTile(
                  title: Text(hotel['hotel_name']),
                  subtitle: Text(hotel['address']),
                  onTap: () {
                    widget.onDestinationSelected(hotel['hotel_name'], hotel['hotel_id']);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
