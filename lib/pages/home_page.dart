import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/NavigationController.dart';
import 'AttractionsPage.dart';
import 'BookingsPage.dart';
import 'CarRentalPage.dart';
import 'TaxiPage.dart';
import 'hotels_page.dart';
import 'saved_page.dart';
import 'profile_page.dart';

class HomePage extends StatelessWidget {
  final NavigationController navController = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0), // Standard AppBar height
        child: Obx(() {
          if (navController.bottomBarIndex.value == 0) {
            return AppBar(
              backgroundColor: Colors.blue,
              title: Text('Booking.com'),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.message),
                  onPressed: () {
                    // Handle message icon press
                  },
                ),
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    // Handle notification icon press
                  },
                ),
              ],
            );
          } else {
            return SizedBox.shrink(); // Return an empty widget
          }
        }),
      ),
      body: Obx(() {
        switch (navController.bottomBarIndex.value) {
          case 0: // 'Search' is selected
            return Column(
              children: [
                Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  color: Colors.blue, // Set the background color of the top bar
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      CategoryButton(
                        icon: Icons.hotel,
                        label: 'Stays',
                        isSelected: navController.topBarIndex.value == 0,
                        onTap: () {
                          navController.changeTopBarPage(0);
                        },
                      ),
                      CategoryButton(
                        icon: Icons.directions_car,
                        label: 'Car Rental',
                        isSelected: navController.topBarIndex.value == 1,
                        onTap: () {
                          navController.changeTopBarPage(1);
                        },
                      ),
                      CategoryButton(
                        icon: Icons.local_taxi,
                        label: 'Taxi',
                        isSelected: navController.topBarIndex.value == 2,
                        onTap: () {
                          navController.changeTopBarPage(2);
                        },
                      ),
                      CategoryButton(
                        icon: Icons.attractions,
                        label: 'Attractions',
                        isSelected: navController.topBarIndex.value == 3,
                        onTap: () {
                          navController.changeTopBarPage(3);
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    switch (navController.topBarIndex.value) {
                      case 0:
                        return HotelsPage();
                      case 1:
                        return CarRentalPage();
                      case 2:
                        return TaxiPage();
                      case 3:
                        return AttractionsPage();
                      default:
                        return HotelsPage();
                    }
                  }),
                ),
              ],
            );
          case 1:
            return SavedPage();  // Saved page
          case 2:
            return BookingPage(); // Bookings page
          case 3:
            return ProfilePage(); // Profile page
          default:
            return HotelsPage(); // Default
        }
      }),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          currentIndex: navController.bottomBarIndex.value,
          onTap: (index) {
            navController.changeBottomBarPage(index);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              backgroundColor: Colors.blue,
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              backgroundColor: Colors.blue,
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_added),
              backgroundColor: Colors.blue,
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              backgroundColor: Colors.blue,
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Function onTap;

  CategoryButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: isSelected ? Colors.white : Colors.blue, // Change color based on selection
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.blue : Colors.white),
            SizedBox(width: 8.0),
            Text(
              label,
              style: TextStyle(color: isSelected ? Colors.blue : Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}