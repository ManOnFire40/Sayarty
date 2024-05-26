import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:sayarty/pages/home_screen.dart';
import 'package:sayarty/providers/car_make_provider.dart';
import 'package:sayarty/providers/auth_provider.dart';
import 'package:sayarty/pages/signup_screen.dart';
import 'package:sayarty/pages/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CarMakeProvider>(
          create: (context) => CarMakeProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        // Add more providers as needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sayarty',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF1F2736),
        ),
        home: const Login(),
      ),
    );
  }
}
