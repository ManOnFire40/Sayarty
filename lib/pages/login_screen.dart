import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../pages/home_screen.dart';
import '../pages/signup_screen.dart';
import '../pages/errorPopup.dart';

String username = '';
String password = '';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // TextEditingController for the text fields
  final TextEditingController _usermailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed
    _usermailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2736),
        title: const Text('Login', style: TextStyle(color: Color(0xFFF7F7F7))),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6679C0).withOpacity(0.3),
                ),
                child: const Icon(
                  Icons.lock,
                  size: 80,
                  color: Color(0xFFF7F7F7),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Welcome to Sayarty',
                style: TextStyle(
                  color: Color(0xFFF7F7F7),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _usermailController,
                decoration: const InputDecoration(
                  labelText: 'mail',
                  prefixIcon: Icon(Icons.person),
                ),
                style: const TextStyle(color: Color(0xFFF7F7F7)),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                style: const TextStyle(color: Color(0xFFF7F7F7)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Update the global variables with the input field text
                  setState(() {
                    username = _usermailController.text;
                    password = _passwordController.text;
                  });
                  // Perform Login logic here
                  await _signin(authService); // The async-await fix

                  print('Username: $username');
                  print('Password: $password');
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Continue with Facebook logic here
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.facebook, color: Colors.blue),
                    SizedBox(width: 10),
                    Text(
                      'Continue with Facebook',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Continue with Google logic here
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.google, color: Colors.red),
                    SizedBox(width: 10),
                    Text(
                      'Continue with Google',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account? ',
                    style: TextStyle(color: Color(0xFFF7F7F7)),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to sign up page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Signup()),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Color(0xFF6679C0)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the browse without authentication page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                },
                child: Text('Browse as a Guest'),

              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signin(AuthProvider authService) async {
    String email = _usermailController.text;
    String password = _passwordController.text;

    try {
      await authService.signInWithEmailAndPassword(email, password);
      if (authService.user != null) {
        print("User is successfully logged in");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        print("Some error happened");
        showErrorDialog(context,
            'An error has occurred During login it could be bad connection or wrong credentials. Please try again.');
      }
    } catch (e) {
      print("Error during sign in: $e");
    }
  }
}
