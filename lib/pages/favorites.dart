import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:sayarty/models/car.dart';
import '../providers/auth_provider.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Car> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    final authService = Provider.of<AuthProvider>(context, listen: false);
    String userId = authService.user?.uid ?? "12345";

    DatabaseReference ref = FirebaseDatabase.instance.ref("users/$userId/favorites");
    DataSnapshot snapshot = await ref.get();

    if (snapshot.exists) {
      Map<String, dynamic> favoriteCars = Map<String, dynamic>.from(snapshot.value as Map);
      List<Car> loadedFavorites = favoriteCars.values.map((carData) {
        return Car.fromMap(Map<String, dynamic>.from(carData));
      }).toList();

      setState(() {
        _favorites = loadedFavorites;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          return Card(
            color: const Color(0xFF1F2736),
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: ListTile(
              leading: const Icon(Icons.favorite, color: Color(0xFF6679C0)),
              title: Text(
                _favorites[index].name,
                style: const TextStyle(color: Color(0xFFF7F7F7)),
              ),
              subtitle: Text(
                _favorites[index].price,
                style: const TextStyle(color: Color(0xFF6679C0)),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Color(0xFFF7F7F7)),
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
