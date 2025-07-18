import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrentUsers extends StatefulWidget {
  const CurrentUsers({super.key});

  @override
  State<CurrentUsers> createState() => _CurrentUsersState();
}

class _CurrentUsersState extends State<CurrentUsers> {
  List<dynamic> users = [];

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('http://192.168.1.9:8080/users'));

    if (response.statusCode == 200) {
      setState(() {
        users = jsonDecode(response.body);
      });
    } else {
      // Optional: handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch users')), 
      );
    }
  }

  Future<void> deleteUser(String id) async {
    final response = await http.delete(Uri.parse('http://192.168.1.9:8080/delete-user/$id'));

    if (response.statusCode == 200) {
      fetchUsers();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete user')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void _showEditDialog(Map user) {
    TextEditingController nameController = TextEditingController(text: user['username']);
    TextEditingController passwordController = TextEditingController(text: user['password']);
    TextEditingController officeController = TextEditingController(text: user['officeLocation']);
    TextEditingController seatController = TextEditingController(text: user['seatNumber']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'User Name')),
              TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password')),
              TextField(controller: officeController, decoration: const InputDecoration(labelText: 'Office Location')),
              TextField(controller: seatController, decoration: const InputDecoration(labelText: 'Seat Number')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final response = await http.put(
                Uri.parse('http://192.168.1.9:8080/update-user/${user['_id']}'),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({
                  'userName': nameController.text.trim(),
                  'password': passwordController.text.trim(),
                  'officeLocation': officeController.text.trim(),
                  'seatNumber': seatController.text.trim(),
                }),
              );

              if (response.statusCode == 200) {
                fetchUsers();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User updated successfully')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update user')),
                );
              }
            },
            child: const Text('Update'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () {
              deleteUser(id);
              Navigator.of(context).pop();
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Management')),
      body: users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(user['username']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Office: ${user['officeLocation']}'),
                        Text('Seat: ${user['seatNumber']}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () => _showEditDialog(user),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                          child: const Text('Edit'),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _confirmDelete(user['_id']),
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
