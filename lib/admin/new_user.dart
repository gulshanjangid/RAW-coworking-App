import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewUser extends StatefulWidget {
  const NewUser({super.key});

  @override
  State<NewUser> createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
  String? selectedLocation;
  String? selectedSeat;

  final Map<String, List<String>> locationSeats = {
    'NEW AATISH': [
      '1st Cabin 1A', '1st Cabin 2A', '1st Cabin 3A', '1st Cabin 4A', '1st Cabin 5A', '1st Cabin 6A',
      '2nd Cabin 1', '2nd Cabin 2', '2nd Cabin 3',
      '3rd Cabin 4', '3rd Cabin 5', '3rd Cabin 6', '3rd Cabin 7', '3rd Cabin 8', '3rd Cabin 9',
    ],
    'MALVIVA NAGAR': [
      'Cabin 1', 'Cabin 2', 'Cabin 3', 'Cabin 4', 'Cabin 5', 'Cabin 6', 'Cabin 7', 'Cabin 8', 'Cabin 9',
      'Cabin 10', 'Cabin 11', 'Cabin 12', 'Cabin 13', 'Cabin 14', 'Cabin 15', 'Cabin 16', 'Cabin 17', 'Cabin 18',
      'Cabin 19', 'Cabin 20', 'Cabin 21', 'Cabin 22', 'Cabin 23', 'Cabin 24', 'Cabin 25', 'Cabin 26', 'Cabin 27',
      'Cabin 28', 'Cabin 29', 'Cabin 30', 'Cabin 31', 'Cabin 32', 'Studio 4', 'Studio 5', 'Studio 5A',
    ],
    'VAISHALI NAGAR': [
      'Cabin 1', 'Cabin 2', 'Cabin 3', 'Cabin 4', 'Cabin 5', 'Cabin 6',
    ],
  };

  Future<void> _addUser() async {
    final String username = _userNameController.text.trim();
    final String password = _passwordController.text.trim();
    final String email = _emailController.text.trim();

    if (username.isEmpty || password.isEmpty || email.isEmpty || selectedLocation == null || selectedSeat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;  
    }

    final url = Uri.parse('https://raw-coworking-app.onrender.com/add-user'); // Replace with your server IP if using a real device
    final body = jsonEncode({
      'username': username,
      'password': password,
      'email': email,
      'officeLocation': selectedLocation,
      'seatNumber': selectedSeat,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User added successfully')),
        );
        Navigator.pop(context);
      } else {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Failed to add user')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF4FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Add New User', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Add New User',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // User Name Field
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(
                hintText: 'User Name',
                hintStyle: const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Email Field
TextField(
  controller: _emailController,
  keyboardType: TextInputType.emailAddress,
  decoration: InputDecoration(
    hintText: 'Email',
    hintStyle: const TextStyle(color: Colors.grey),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.purple),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.purple, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
  ),
),
const SizedBox(height: 20),

            // Location Dropdown
            DropdownButtonFormField<String>(
              value: selectedLocation,
              decoration: InputDecoration(
                hintText: 'Select Location',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: locationSeats.keys.map((location) {
                return DropdownMenuItem<String>(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedLocation = value;
                  selectedSeat = null;
                });
              },
            ),
            const SizedBox(height: 20),

            // Seat Dropdown
            if (selectedLocation != null)
              DropdownButtonFormField<String>(
                value: selectedSeat,
                decoration: InputDecoration(
                  hintText: 'Select Seat/Cabin',
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.purple),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.purple, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: locationSeats[selectedLocation]!.map((seat) {
                  return DropdownMenuItem<String>(
                    value: seat,
                    child: Text(seat),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSeat = value;
                  });
                },
              ),
            const SizedBox(height: 30),

            // Add User Button
            ElevatedButton(
              onPressed: _addUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Add User',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
