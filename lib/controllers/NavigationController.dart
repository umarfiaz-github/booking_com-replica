import 'package:get/get.dart';

class NavigationController extends GetxController {
  var topBarIndex = 0.obs;    // Controls top bar items (Stays, Car Rental, Taxi, Attractions)
  var bottomBarIndex = 0.obs; // Controls bottom navigation items (Search, Saved, Bookings, Profile)

  void changeTopBarPage(int index) {
    topBarIndex.value = index;
  }

  void changeBottomBarPage(int index) {
    bottomBarIndex.value = index;
  }

  void navigateToPage(int index) {
    changeBottomBarPage(index);
    switch (index) {
      case 0:
        Get.toNamed('/search');
        break;
      case 1:
        Get.toNamed('/saved');
        break;
      case 2:
        Get.toNamed('/bookings');
        break;
      case 3:
        Get.toNamed('/profile');
        break;
    }
  }
}