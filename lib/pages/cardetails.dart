import 'package:flutter/material.dart';
import 'package:sayarty/models/car.dart';

class CarDetails extends StatelessWidget {
  final Car car;

  const CarDetails({Key? key, required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(car.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(car.image),
            SizedBox(height: 16.0),
            Text(
              car.name,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Price: ${car.price}'),
            SizedBox(height: 8.0),
            Text('Make: ${car.make}'),
            SizedBox(height: 8.0),
            Text('Transmission: ${car.transmission}'),
            SizedBox(height: 8.0),
            Text('Rating: ${car.rating}'),
            SizedBox(height: 8.0),
            Text('Description: ${car.description}'),
          ],
        ),
      ),
    );
  }
}
