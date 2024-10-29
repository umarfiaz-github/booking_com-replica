import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'destination_search_page.dart';

class HotelsPage extends StatefulWidget {
  @override
  _HotelsPageState createState() => _HotelsPageState();
}

class _HotelsPageState extends State<HotelsPage> {
  String? destination;
  String? destinationId;
  DateTimeRange? selectedDates;
  int rooms = 1;
  int adults = 2;
  int children = 0;
  bool pets = false;
  List<dynamic> hotels = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Destination field with map integration
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_on),
                    hintText: destination ?? 'Enter your destination',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DestinationSearchPage(
                          onDestinationSelected: (selectedDestination, selectedDestinationId) {
                            setState(() {
                              destination = selectedDestination;
                              destinationId = selectedDestinationId;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                // Calendar field for date selection
                TextField(
                  readOnly: true,
                  onTap: () async {
                    DateTimeRange? dates = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2026),
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
                SizedBox(height: 10),
                // Room and guest selection field
                TextField(
                  readOnly: true,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return RoomGuestSelection(
                          initialRooms: rooms,
                          initialAdults: adults,
                          initialChildren: children,
                          initialPets: pets,
                          onSelectionChanged: (selectedRooms, selectedAdults, selectedChildren, selectedPets) {
                            setState(() {
                              rooms = selectedRooms;
                              adults = selectedAdults;
                              children = selectedChildren;
                              pets = selectedPets;
                            });
                          },
                        );
                      },
                    );
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.people),
                    hintText: 'Rooms: $rooms, Adults: $adults, Children: $children',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
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
          // Display additional sections as per the screenshot
          _buildLastMinuteIdeasSection(),
          _buildTravelMoreSpendLessSection(),
          _buildNeedIdeasSection(),
          _buildExplorePakistanSection(),
          _buildMoreForYouSection(),
        ],
      ),
    );
  }

  Future<void> _performSearch() async {
    if (destination == null || selectedDates == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      return;
    }

    final checkinDate = selectedDates!.start.toIso8601String().split('T')[0];
    final checkoutDate = selectedDates!.end.toIso8601String().split('T')[0];
    final apiKey = dotenv.env['BOOKING_API_KEY'];

    final url = Uri.parse(
        'https://booking-com15.p.rapidapi.com/api/v1/hotels/searchHotels?dest_id=$destinationId&checkin_date=$checkinDate&checkout_date=$checkoutDate&room_qty=$rooms&adults=$adults&children_qty=$children&units=metric&temperature_unit=c&languagecode=en-us&currency_code=AED');

    final response = await http.get(
      url,
      headers: {
        'x-rapidapi-host': 'booking-com15.p.rapidapi.com',
        'x-rapidapi-key': apiKey ?? '',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        hotels = data['result'];
      });
    } else if (response.statusCode == 429) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You have exceeded the monthly quota for requests. Please upgrade your plan on RapidAPI.'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching hotels'),
        ),
      );
    }
  }

  Widget _buildLastMinuteIdeasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Last-minute ideas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 10),
        Container(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hotels.length,
            itemBuilder: (context, index) {
              final hotel = hotels[index];
              return Container(
                width: 250,
                margin: EdgeInsets.only(left: 16.0, right: index == hotels.length - 1 ? 16.0 : 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(hotel['image']),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(hotel['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(hotel['price']),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTravelMoreSpendLessSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Travel more, spend less', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Card(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('You\'re at Genius level 1 in our loyalty programme', style: TextStyle(color: Colors.white)),
            ),
          ),
          Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('10% discounts on stays\nEnjoy discounts at participating properties worldwide'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeedIdeasSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Need ideas?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Travellers from Pakistan often book'),
            SizedBox(height: 10),
            Container(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCityCard('Lahore', 'assets/images/lahore.jpg'),
                  _buildCityCard('Islamabad', 'assets/images/islamabad.jpg'),
                  _buildCityCard('Dubai', 'assets/images/dubai.jpg'),
                  _buildCityCard('Karachi', 'assets/images/karachi.jpg'),
                  _buildCityCard('Makkah', 'assets/images/makkah.jpg'),
                  _buildCityCard('Baku', 'assets/images/baku.jpg'),
                  _buildCityCard('Al Madina', 'assets/images/al_madina.jpg'),
                  _buildCityCard('Istanbul', 'assets/images/istanbul.jpg'),
                  _buildCityCard('Kuala Lumpur', 'assets/images/kuala_lumpur.jpg'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityCard(String city, String imagePath) {
    return Container(
      width: 100,
      margin: EdgeInsets.only(right: 16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            SizedBox(height: 8),
            Text(city, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildExplorePakistanSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Explore Pakistan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('These popular destinations have a lot to offer'),
          SizedBox(height: 10),
          Container(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCityCard('Islamabad', 'assets/images/islamabad.jpg'),
                _buildCityCard('Lahore', 'assets/images/lahore.jpg'),
                _buildCityCard('Nathiagali', 'assets/images/nathiagali.jpg'),
                _buildCityCard('Muree', 'assets/images/muree.jpg'),
                _buildCityCard('Karachi', 'assets/images/karachi.jpg'),
                _buildCityCard('Skardu', 'assets/images/skardu.jpg'),
                _buildCityCard('Rawalpindi', 'assets/images/rawalpindi.jpg'),
                _buildCityCard('Naran', 'assets/images/naran.jpg'),
                _buildCityCard('Hunza', 'assets/images/hunza.jpg'),
                _buildCityCard('Multan', 'assets/images/multan.jpg'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreForYouSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('More for you', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/trip.jpg', fit: BoxFit.cover),
                  SizedBox(height: 10),
                  Text('Small trip. Big fun.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Finish your year with a mini break and save at least 15%.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoomGuestSelection extends StatefulWidget {
  final int initialRooms;
  final int initialAdults;
  final int initialChildren;
  final bool initialPets;
  final Function(int, int, int, bool) onSelectionChanged;

  RoomGuestSelection({
    required this.initialRooms,
    required this.initialAdults,
    required this.initialChildren,
    required this.initialPets,
    required this.onSelectionChanged,
  });

  @override
  _RoomGuestSelectionState createState() => _RoomGuestSelectionState();
}

class _RoomGuestSelectionState extends State<RoomGuestSelection> {
  late int rooms;
  late int adults;
  late int children;
  late bool pets;

  @override
  void initState() {
    super.initState();
    rooms = widget.initialRooms;
    adults = widget.initialAdults;
    children = widget.initialChildren;
    pets = widget.initialPets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Rooms'),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (rooms > 1) setState(() => rooms--);
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text('$rooms'),
                  IconButton(
                    onPressed: () => setState(() => rooms++),
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Adults'),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (adults > 1) setState(() => adults--);
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text('$adults'),
                  IconButton(
                    onPressed: () => setState(() => adults++),
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Children'),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (children > 0) setState(() => children--);
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text('$children'),
                  IconButton(
                    onPressed: () => setState(() => children++),
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pets'),
              Switch(
                value: pets,
                onChanged: (value) => setState(() => pets = value),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              widget.onSelectionChanged(rooms, adults, children, pets);
              Navigator.pop(context);
            },
            child: Text('Apply'),
          ),
        ],
      ),
    );
  }
}
