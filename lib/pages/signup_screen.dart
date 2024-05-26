import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../pages/home_screen.dart';
import '../pages/login_screen.dart';
import '../pages/errorPopup.dart';
import '../Users_Read_write.dart';

String removeCharAndAfter(String email, String char) {
  int index = email.indexOf(char);
  if (index == -1) {
    return email;
  } else {
    return email.substring(0, index);
  }
}

// Define global variables for gender and profile type
String globalGender = 'Male';
String globalProfileType = 'Shopper';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String selectedGender = globalGender; // Initialize with globalGender
  String selectedProfileType =
      globalProfileType; // Initialize with globalProfileType

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF7F7F7)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title:
            const Text('Sign Up', style: TextStyle(color: Color(0xFFF7F7F7))),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF7F7F7).withOpacity(0.3),
                    ),
                  ),
                  const Icon(Icons.person_add,
                      size: 60, color: Color(0xFFF7F7F7)),
                ],
              ),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email, color: Color(0xFFF7F7F7)),
                ),
                style: const TextStyle(color: Colors.blue),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: Color(0xFFF7F7F7)),
                ),
                style: const TextStyle(color: Color(0xFFF7F7F7)),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone, color: Color(0xFFF7F7F7)),
                ),
                style: const TextStyle(color: Color(0xFFF7F7F7)),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.home, color: Color(0xFFF7F7F7)),
                ),
                style: const TextStyle(color: Color(0xFFF7F7F7)),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Gender:',
                    style: TextStyle(color: Color(0xFFF7F7F7)),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: selectedGender,
                    items:
                        <String>['Male', 'Female', 'Other'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: const TextStyle(color: Color(0xFFF7F7F7))),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGender = newValue!;
                        globalGender = newValue; // Update global variable
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Profile Type:',
                    style: TextStyle(color: Color(0xFFF7F7F7)),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: selectedProfileType,
                    items: <String>['Vendor', 'Shopper'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: const TextStyle(color: Color(0xFFF7F7F7))),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedProfileType = newValue!;
                        globalProfileType = newValue; // Update global variable
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _signUp(authService);
                },
                child: const Text('Sign Up'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF7F7F7)),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Sign up with Google logic here
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.google, color: Colors.red),
                    SizedBox(width: 10),
                    Text(
                      'Sign Up with Google',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Sign up with Facebook logic here
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.facebook, color: Colors.blue),
                    SizedBox(width: 10),
                    Text(
                      'Sign Up with Facebook',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signUp(AuthProvider authService) async {
    String email = emailController.text;
    String password = passwordController.text;
    String address = addressController.text;
    String phoneNumber = phoneController.text;
    String UserName = removeCharAndAfter(email, '@');
    String type = selectedProfileType;
    String gen = selectedGender;
    //    Vendor', 'Shopper'

    FirebaseService write_Read_User = FirebaseService();

    try {
      await authService.signUpWithEmailAndPassword(email, password);
      if (authService.user != null) {
        print("User is successfully created");
        String userId = authService.user!.uid;

        write_Read_User.writeUserData(
            userId, UserName, email, phoneNumber, address, type, gen);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        print("Some error happened");
        showErrorDialog(context,
            'An error has occurred During Sign up it could be bad connection or invalid sign up data or already existing credentials. Please try again.');
      }
    } catch (e) {
      print("Error during sign up: $e");
    }
  }
}
