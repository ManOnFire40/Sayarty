import 'package:flutter/material.dart';
import 'package:sayarty/models/car_make.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class CarMakeProvider extends ChangeNotifier {
  final List<CarMake> _carMakes = [];
  final databaseReference = FirebaseDatabase.instance.reference();

  Future<void> fetchCarMakes() async {
    if (_carMakes.isNotEmpty) {
      return;
    }
    try {
      databaseReference.child('car_makes').onChildAdded.listen((event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        _carMakes.add(CarMake(name: data['name'], image: data['image']));
        notifyListeners();
      });
    } catch (error) {
      print(error);
    }
  }

  List<CarMake> get carMakes {
    return [..._carMakes];
  }
}
