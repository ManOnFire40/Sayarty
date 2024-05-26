import 'package:flutter/material.dart';
import 'package:sayarty/models/car.dart';

class FavoritesPage extends StatefulWidget {
  final List<Car> favorites;

  const FavoritesPage({super.key, required this.favorites});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late List<Car> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = widget.favorites;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          return Card(
            color: Color(0xFF1F2736),
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: ListTile(
              leading: Icon(Icons.favorite, color: Color(0xFF6679C0)),
              title: Text(
                _favorites[index].name,
                style: TextStyle(color: Color(0xFFF7F7F7)),
              ),
              subtitle: Text(
                _favorites[index].price,
                style: TextStyle(color: Color(0xFF6679C0)),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Color(0xFFF7F7F7)),
                onPressed: () {
                  setState(() {
                    _favorites.removeAt(index);
                  });
                  // Handle remove from favorites logic here
                },
              ),
              onTap: () {
                // Handle item click logic here
              },
            ),
          );
        },
      ),
    );
  }
}
