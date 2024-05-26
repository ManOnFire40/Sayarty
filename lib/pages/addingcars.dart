import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart' as myAuth;
import 'package:sayarty/models/car.dart';

class AddCarScreen extends StatefulWidget {
  final Function(Car) addCar;

  const AddCarScreen({super.key, required this.addCar});

  @override
  _AddCarScreenState createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedMake;
  String? _selectedTransmission;
  String userId = '';
  String? userEmail;

  final List<String> carMakes = ['Toyota', 'Ford', 'BMW', 'Honda'];
  final List<String> carMakeImages = [
    'https://www.carlogos.org/car-logos/toyota-logo-2005-download.png',
    'https://www.carlogos.org/car-logos/ford-logo-2003.png',
    'https://www.carlogos.org/car-logos/bmw-logo-2020-blue-white.png',
    'https://www.carlogos.org/car-logos/honda-logo-1700x1150.png'
  ];
  final List<String> transmissions = ['Automatic', 'Manual'];

  @override
  void initState() {
    super.initState();
    final authService =
        Provider.of<myAuth.AuthProvider>(context, listen: false);
    final user = authService.user;
    if (user != null) {
      userId = user.uid;
      userEmail = user.email;
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newCar = Car(
        id: '', // This will be set by Firebase
        name: _nameController.text,
        price: _priceController.text,
        image: _imageController.text,
        make: _selectedMake!,
        makeImage: carMakeImages[carMakes.indexOf(_selectedMake!)],
        comments: [],
        description: '',
        rating: 0,
        transmission: _selectedTransmission!,
        userId: userId,
        userPhone: _phoneController.text,
        userEmail: userEmail ?? _emailController.text,
      );

      final databaseReference =
          FirebaseDatabase.instance.ref().child("cars").push();
      databaseReference.set(newCar.toMap()).then((_) {
        setState(() {
          widget.addCar(newCar);
        });
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add car: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Car for Sale'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Car Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the car name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the car price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageController,
                decoration: InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the image URL';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the phone number';
                  }
                  return null;
                },
              ),
              if (userEmail == null)
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the email';
                    }
                    return null;
                  },
                ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Make'),
                value: _selectedMake,
                items: carMakes.map((make) {
                  return DropdownMenuItem(
                    value: make,
                    child: Text(make),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMake = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select the car make';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Transmission'),
                value: _selectedTransmission,
                items: transmissions.map((transmission) {
                  return DropdownMenuItem(
                    value: transmission,
                    child: Text(transmission),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTransmission = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select the transmission type';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Car'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
