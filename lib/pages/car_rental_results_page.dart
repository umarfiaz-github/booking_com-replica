import 'package:flutter/material.dart';

class CarRentalResultsPage extends StatelessWidget {
  final List<dynamic> carRentals;

  CarRentalResultsPage({required this.carRentals});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Rental Results'),
      ),
      body: ListView.builder(
        itemCount: carRentals.length,
        itemBuilder: (context, index) {
          final car = carRentals[index];
          return Card(
            child: ListTile(
              title: Text(car['car_name'] ?? 'Unknown Car'),
              subtitle: Text('Price: ${car['price']['amount']} ${car['price']['currency']}'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Handle tap to view more details
              },
            ),
          );
        },
      ),
    );
  }
}
