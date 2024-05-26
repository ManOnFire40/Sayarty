import 'package:flutter/material.dart';
import 'package:sayarty/components/car_make.dart';

class CarMakes extends StatefulWidget {
  const CarMakes({super.key});

  @override
  State<CarMakes> createState() => _CarMakesState();
}

class _CarMakesState extends State<CarMakes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: ListView(
        children: [
          _searchBar(context),
          const SizedBox(height: 20),
          const CarMake(
            showAll: true,
          ),
        ],
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF272F3E),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(color: Color(0xFFACB4C4)),
          border: InputBorder.none,
          icon: Icon(
            Icons.search,
            color: Color(0xFFACB4C4),
          ),
        ),
        style: TextStyle(color: Color(0xFFF7F7F7)),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1F2736),
      title:
          const Text('Car Makes', style: TextStyle(color: Color(0xFFF7F7F7))),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFFF7F7F7)),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
