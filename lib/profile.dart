import 'package:flutter/material.dart';
import 'package:votingapp/login/Login.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Function to handle logout
  void _logout() {
    // Navigate back to the login page
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Login(
                  phoneNumber: '',
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Profile',
        ),
      ),
    );
  }
}
