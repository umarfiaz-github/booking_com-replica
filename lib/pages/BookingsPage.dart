import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingPage extends StatelessWidget {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0), // Increase the height of the app bar
        child: AppBar(
          backgroundColor: Colors.blue,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trips',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.help_outline),
                          onPressed: () {
                            // Handle help icon action
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            // Handle add icon action
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Buttons section
          Container(
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTripButton('Active', 0, Colors.white),
                _buildTripButton('Past', 1, Colors.blue[100]!),
                _buildTripButton('Cancelled', 2, Colors.blue[100]!),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                // Update button states if necessary
              },
              children: [
                _buildTripContent(
                  imageUrl: 'https://thumbs.dreamstime.com/z/globe-landmark-icons-18979647.jpg?ct=jpeg',
                  title: 'Where to next?',
                  description: 'You haven\'t started any trips yet. When you\'ve made a booking, it will appear here.',
                ),
                _buildTripContent(
                  imageUrl: 'https://img.freepik.com/premium-photo/blue-location-pin-sign-icon-gps-navigation-map-road-direction-internet-search-bar-technology-symbol-position-place-background-with-find-route-mark-travel-destination-navigator-3d-rendering_79161-1996.jpg?w=826',
                  title: 'Revisit past trips',
                  description: 'Here you can refer to all past trips and get inspired for your next ones.',
                ),
                _buildTripContent(
                  imageUrl: 'https://cdn.vectorstock.com/i/1000x1000/12/39/flat-color-location-icon-on-paper-map-vector-21491239.jpg',
                  title: 'Sometimes plans change',
                  description: "Here you can refer to all trips you've cancelled. Maybe next time!",
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          // Navigate to the respective pages
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildTripButton(String label, int pageIndex, Color backgroundColor) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      ),
      onPressed: () {
        _pageController.animateToPage(
          pageIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Text(
        label,
        style: TextStyle(
          color: pageIndex == 0 ? Colors.blue : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTripContent({required String imageUrl, required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(imageUrl),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
