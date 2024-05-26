import 'package:flutter/material.dart';
import 'package:sayarty/models/car.dart';
import 'package:sayarty/models/order.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class CheckoutPage extends StatelessWidget {
  final Car selectedCar;

  const CheckoutPage({Key? key, required this.selectedCar}) : super(key: key);

  Future<void> _placeOrder(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to be logged in to place an order')),
      );
      return;
    }

    final orderId = FirebaseDatabase.instance.reference().child('orders').push().key!;
    final orderDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    final order = Order(
      id: orderId,
      userId: user.uid,
      car: selectedCar,
      orderDate: orderDate,
    );

    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child('orders').child(orderId).set(order.toMap());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order placed successfully')),
    );

    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selected Car: ${selectedCar.name}', style: TextStyle(fontSize: 18)),
            Text('Price: ${selectedCar.price}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _placeOrder(context),
              child: Text('Confirm Order'),
            ),
          ],
        ),
      ),
    );
  }
}
