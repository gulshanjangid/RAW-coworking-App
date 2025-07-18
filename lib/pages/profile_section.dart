import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileHeader extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String cabinNumber;

  const UserProfileHeader({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.cabinNumber,
  });

  @override
  _UserProfileHeaderState createState() => _UserProfileHeaderState();
}

class _UserProfileHeaderState extends State<UserProfileHeader> {
  File? _profileImage;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Image picking error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color.fromARGB(255, 152, 26, 26),
      child: Row(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              children: [
                // CircleAvatar(
                //   radius: 40,
                //   backgroundImage: _profileImage != null
                //       ? FileImage(_profileImage!)
                //       : const AssetImage('assets/images/user.png') as ImageProvider,
                // ),
                // Positioned(
                //   bottom: 0,
                //   right: 0,
                //   child: Container(
                //     padding: const EdgeInsets.all(4),
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       shape: BoxShape.circle,
                //     ),
                //     child: const Icon(Icons.camera_alt, size: 18, color: Colors.black),
                //   ),
                // ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.userEmail,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Cabin / Seat: ${widget.cabinNumber}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
