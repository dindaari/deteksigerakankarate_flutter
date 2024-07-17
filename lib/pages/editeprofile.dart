import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:motion_martial/api/service.dart';
import 'package:motion_martial/pages/profile_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _saveProfile(BuildContext context) {
    sendProfileData(context);
  }

  Future<void> sendProfileData(BuildContext context) async {
  String base64Image = '';
  if (_image != null) {
    List<int> imageBytes = _image!.readAsBytesSync();
    base64Image = base64Encode(imageBytes);
  }

  try {
    final response = await http.post(
      Uri.parse(AppServices.getEditprofilEndpoint()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer your_token_here', // Ensure you replace this with the actual token
      },
      body: jsonEncode(<String, dynamic>{
        'username': _nameController.text,
        'photo': base64Image,
      }),
    );

    if (response.statusCode == 200) {
      print('Profile updated successfully');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    } else {
      print('Failed to update profile: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error sending profile data: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edite Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 24),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage: _image != null
                            ? FileImage(_image!)
                            : null, // Remove the AssetImage for the default
                        backgroundColor: Colors.grey.shade300, // Optional: background color for the CircleAvatar
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: _pickImage,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                // Rest of your code...

                SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _saveProfile(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 14), // Sesuaikan dengan kebutuhan Anda
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Update',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
