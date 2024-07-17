import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:motion_martial/api/service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'editeprofile.dart'; // Assuming this is correctly imported
import 'signin.dart'; // Assuming this is correctly imported

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>> _profileData;

  @override
  void initState() {
    super.initState();
    _profileData = fetchProfile();
  }

  Future<Map<String, dynamic>> fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('No token found');
    }

    print('Access Token: $token');

    final url = Uri.parse(AppServices.getProtectedEndpoint());
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      print('Profile Data: ${response.body}');
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      throw Exception('Failed to load profile: ${response.statusCode}');
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('accessToken');
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.bottomToTop,
          child: Signin(),
        ),
      );
    } catch (error) {
      print('Logout error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'PROFILE',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.red.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FutureBuilder<Map<String, dynamic>>(
            future: _profileData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                      'Failed to load user profile. Error: ${snapshot.error}'),
                );
              } else if (snapshot.hasData) {
                final userProfile = UserProfile.fromJson(snapshot.data!);
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 24),
                      _buildProfilePicture(userProfile.photo),
                      SizedBox(height: 16),
                      _buildProfileActions(context, userProfile),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Text('No data found'),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture(String photoUrl) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      child: CircleAvatar(
        radius: 80,
        backgroundImage: NetworkImage(photoUrl),
      ),
    );
  }

  Widget _buildProfileActions(BuildContext context, UserProfile userProfile) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16),
          Text(
            'Name: ${userProfile.name}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Email: ${userProfile.email}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),
          _buildEditProfileButton(),
          SizedBox(height: 16),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildEditProfileButton() {
    return ElevatedButton(
      onPressed: _editProfile,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        'Edit Profile',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  void _editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfile()),
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: logout,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        padding: EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        'Logout',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}

class UserProfile {
  final String name;
  final String email;
  final String photo;

  UserProfile({required this.name, required this.email, required this.photo});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    String photoPath = json['profile_picture'] ?? '/static/uploads/';
    // Assuming your host is 'http://your-server.com'
    String fullPhotoUrl = photoPath.startsWith('http')
        ? photoPath
        : 'http://194.31.53.102:21071/user/image/66929cdb3602063a881df736.jpg';
    return UserProfile(
      name: json['username'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
      photo: fullPhotoUrl,
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: storage.read(key: 'auth_token'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data != null) {
          return MaterialApp(
            home: ProfileScreen(),
          );
        } else {
          return MaterialApp(
            home: Signin(),
          );
        }
      },
    );
  }
}
