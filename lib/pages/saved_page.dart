import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/NavigationController.dart';

class SavedPage extends StatelessWidget {
  final NavigationController navigationController = Get.find();

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
                      'Saved',
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
                            // Add your question mark action here
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: () {
                            // Add your add action here
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Image.asset(
            'assets/images/saved_illustration.jpg', // Ensure the image is in the assets folder and update the path accordingly
            height: 200,
          ),
          SizedBox(height: 20),
          Text(
            'Save what you like for later',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Create lists of your favourite properties to help you\nshare, compare and book.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Add your search logic here
            },
            child: Text('Start your search'),
          ),
          TextButton(
            onPressed: () {
              // Add your create list logic here
            },
            child: Text('Create a list'),
          ),
          Spacer(),
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.red),
            title: Text('My next trip'),
            subtitle: Text('0 properties'),
            trailing: Icon(Icons.more_vert),
          ),
          SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          currentIndex: navigationController.bottomBarIndex.value,
          onTap: (index) => navigationController.navigateToPage(index),
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
      ),
    );
  }
}
