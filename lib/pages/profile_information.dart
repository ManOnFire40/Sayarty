import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarty/pages/errorPopup.dart';
import '../providers/auth_provider.dart';
import '../Users_Read_write.dart';
import '../pages/VIP_message.dart';

String removeCharAndAfter(String email, String char) {
  int index = email.indexOf(char);
  if (index == -1) {
    // Character not found, return the original email
    return email;
  } else {
    // Return the substring from the start to the character's position
    return email.substring(0, index);
  }
}

class ProfileInformation extends StatefulWidget {
  const ProfileInformation({super.key});

  @override
  _ProfileInformationState createState() => _ProfileInformationState();
}

class _ProfileInformationState extends State<ProfileInformation> {
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with default values
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _nameController = TextEditingController();
    _emailController = TextEditingController();

    // Fetch user data
    fetchUserData();
  }

  FirebaseService readWriteUsers = FirebaseService();

  Future<void> fetchUserData() async {
    final authService = Provider.of<AuthProvider>(context, listen: false);
//        readMail       readUserUserName
    String userId = authService.user?.uid ?? "12345";
    String? mail = await readWriteUsers.readMail(userId);
    String? userName = await readWriteUsers.readUserUserName(userId);

    String? phoneNumber = await readWriteUsers.readUserPhoneNumber(userId);
    String? address = await readWriteUsers.readUserAddress(userId);

    setState(() {
      _phoneController.text = phoneNumber ?? '+1234567890';
      _addressController.text = address ?? '123 Main St, Anytown, USA';
      _nameController.text = userName ?? 'ElGamed';
      _emailController.text = mail ?? 'John.doe@example.com';
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _phoneController.dispose();
    _addressController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF6679C0).withOpacity(0.3),
                ),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Color(0xFFF7F7F7),
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Your Profile',
                style: TextStyle(
                  color: Color(0xFFF7F7F7),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _buildEditableField(
                context,
                label: 'UserName',
                controller: _nameController,
                icon: Icons.person,
              ),
              Divider(color: Color(0xFF6679C0)),
              _buildEditableField(
                context,
                label: 'Email',
                controller: _emailController,
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              Divider(color: Color(0xFF6679C0)),
              _buildEditableField(
                context,
                label: 'Phone',
                controller: _phoneController,
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              Divider(color: Color(0xFF6679C0)),
              _buildEditableField(
                context,
                label: 'Address',
                controller: _addressController,
                icon: Icons.location_city,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final authService =
                        Provider.of<AuthProvider>(context, listen: false);

                    String userId = authService.user!.uid;
                    String? mail = await readWriteUsers.readMail(userId);
                    String? userName =
                        await readWriteUsers.readUserUserName(userId);

                    String? phoneNumber =
                        await readWriteUsers.readUserPhoneNumber(userId);
                    String? address =
                        await readWriteUsers.readUserAddress(userId);

                    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////dam  gedan
                    String updated_username = _nameController.text;
                    String updated_phone = _phoneController.text;
                    String updated_mail = _emailController.text;
                    String updated_address = _addressController.text;
                    print("Old Mail: $mail      Updated Mail: $updated_mail ");
                    print(
                        "Old Name: $userName      Updated Name: $updated_username ");
                    print(
                        "Old Phone: $phoneNumber      Updated phone: $updated_phone ");
                    print(
                        "Old address: $address      Updated address: $updated_address ");

                    if (updated_username != userName) {
                      await readWriteUsers.updateUserName(
                          userId, updated_username);
                    }

                    if (updated_phone != phoneNumber) {
                      await readWriteUsers.updateUserPhoneNumber(
                          userId, updated_phone);
                    }
                    if (updated_mail != mail) {
                      await readWriteUsers.updateUserEmail(
                          context, userId, updated_mail);
                    }
                    if (updated_address != address) {
                      await readWriteUsers.updateUserAddress(
                          userId, updated_address);
                    }
                    showNotifyDialog(context, "Profile updated Successfully");
                  } catch (err) {
                    showErrorDialog(
                        context, "someThing went wrong during update profile");
                  }

                  // Save Profile logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6679C0), // Background color
                ),
                child: Text('Save Profile',
                    style: TextStyle(color: Color(0xFFF7F7F7))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFFF7F7F7)),
      title: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Color(0xFFF7F7F7)),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFF7F7F7)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF6679C0)),
          ),
        ),
        style: TextStyle(color: Color(0xFFF7F7F7)),
        keyboardType: keyboardType,
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProfileInformation(),
  ));
}
