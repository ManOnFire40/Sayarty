import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import './pages/errorPopup.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref("Users");

  void writeUserData(String userId, String name, String email,
      String phoneNumber, String address, String type, String gender) async {
    await _database.child('users').child(userId).set({
      'username': name,
      'email': email,
      'PhoneNumber': phoneNumber,
      'Address': address,
      'Type': type,
      'Gender': gender
    }).then((_) {
      print("User data saved successfully!");
    }).catchError((error) {
      print("Error writing to database: $error");
    });
  }

  Future<String?> readUserUserName(String userId) async {
    try {
      DataSnapshot snapshot = await _database.child('users').get();
      Map Users = snapshot.value as Map;
      String name = Users[userId]['username'] as String;
      print(name);
      return name;
    } catch (error) {
      print("Error reading phone number from database: $error");
      return null;
    }
  }

  Future<String?> readMail(String userId) async {
    try {
      DataSnapshot snapshot = await _database.child('users').get();
      Map Users = snapshot.value as Map;
      String mail = Users[userId]['email'] as String;
      print(mail);
      return mail;
    } catch (error) {
      print("Error reading phone number from database: $error");
      return null;
    }
  }

  Future<String?> readUserPhoneNumber(String userId) async {
    try {
      DataSnapshot snapshot = await _database.child('users').get();
      Map Users = snapshot.value as Map;
      String phoneNumber = Users[userId]['PhoneNumber'] as String;
      print(phoneNumber);
      return phoneNumber;
    } catch (error) {
      print("Error reading phone number from database: $error");
      return null;
    }
  }

  Future<String?> readUserAddress(String userId) async {
    try {
      DataSnapshot snapshot = await _database.child('users').get();
      Map Users = snapshot.value as Map;
      print(Users);
      String address = Users[userId]['Address'] as String;
      print(address);
      return address;
    } catch (error) {
      print("Error reading address from database: $error");
      return null;
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  still checking

  Future<void> updateUserName(String userId, String name) async {
    try {
      await _database.child('users').child(userId).update({'username': name});
      print("User name updated successfully!");
    } catch (error) {
      print("Error updating user name: $error");
    }
  }
  //changeUserEmail( BuildContext context, String newEmail, String password)

  Future<void> updateUserEmail(
      BuildContext context, String userId, String email) async {
    try {
      await _database.child('users').child(userId).update({'email': email});
      print("User email updated successfully!");
    } catch (error) {
      print("Error updating user email: $error");
    }
  }

  Future<void> updateUserPhoneNumber(String userId, String phoneNumber) async {
    try {
      await _database
          .child('users')
          .child(userId)
          .update({'PhoneNumber': phoneNumber});
      print("User phone number updated successfully!");
    } catch (error) {
      print("Error updating user phone number: $error");
    }
  }

  Future<void> updateUserAddress(String userId, String address) async {
    try {
      await _database.child('users').child(userId).update({'Address': address});
      print(userId);
      print("User address updated successfully!");
    } catch (error) {
      print("Error updating user address: $error");
    }
  }

  Future<void> changeUserEmail(BuildContext context, String newEmail) async {
    try {
      User user = FirebaseAuth.instance.currentUser!;

      // Update the email
      await user.updateEmail(newEmail);

      // Send a verification email to the new address
      await user.sendEmailVerification();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Email address updated successfully. Please verify your new email.')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update email: $e')));
    }
  }
}
