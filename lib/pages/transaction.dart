import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:sayarty/models/car.dart';
import '../providers/auth_provider.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<Car> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() async {
    final authService = Provider.of<AuthProvider>(context, listen: false);
    String userId = authService.user?.uid ?? "12345";

    DatabaseReference ref = FirebaseDatabase.instance.ref("users/$userId/transactions");
    DataSnapshot snapshot = await ref.get();

    if (snapshot.exists) {
      Map<String, dynamic> transactionCars = Map<String, dynamic>.from(snapshot.value as Map);
      List<Car> loadedTransactions = transactionCars.values.map((carData) {
        return Car.fromMap(Map<String, dynamic>.from(carData));
      }).toList();

      setState(() {
        _transactions = loadedTransactions;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _transactions.length,
        itemBuilder: (context, index) {
          return Card(
            color: const Color(0xFF1F2736),
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: ListTile(
              leading: const Icon(Icons.shopping_cart, color: Color(0xFF6679C0)),
              title: Text(
                _transactions[index].name,
                style: const TextStyle(color: Color(0xFFF7F7F7)),
              ),
              subtitle: Text(
                _transactions[index].price,
                style: const TextStyle(color: Color(0xFF6679C0)),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Color(0xFFF7F7F7)),
                onPressed: () {
                  setState(() {
                    _transactions.removeAt(index);
                  });
                  // Handle remove from transactions logic here
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
