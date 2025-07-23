import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';


class EventManage extends StatefulWidget {
  const EventManage({super.key});

  @override
  State<EventManage> createState() => _EventManageState();
}

class _EventManageState extends State<EventManage> {
  final String baseUrl = 'https://raw-coworking-app.onrender.com/api/events'; // Use your local IP if testing on a device

  List<Event> events = [];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String selectedCategory = 'Event';
  String filterCategory = 'All';

  DateTime selectedDate = DateTime.now();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> fetchEvents() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/events'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          events = data.map((e) => Event.fromJson(e)).toList();
        });
      } else {
        print('Failed to fetch events');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _addEvent() async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) return;

    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/add-event'))
      ..fields['title'] = titleController.text
      ..fields['description'] = descriptionController.text
      ..fields['date'] = selectedDate.toIso8601String()
      ..fields['category'] = selectedCategory;

    if (_selectedImage != null) {
      request.files.add(await http.MultipartFile.fromPath('image', _selectedImage!.path));
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        fetchEvents(); // Refresh list
        titleController.clear();
        descriptionController.clear();
        selectedCategory = 'Event';
        _selectedImage = null;
        setState(() {});
      } else {
        print('Failed to add event');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _deleteEvent(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/delete-event/$id'));

      if (response.statusCode == 200) {
        fetchEvents(); // Refresh list
      } else {
        print('Failed to delete event');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  List<Event> get filteredEvents {
    if (filterCategory == 'All') {
      return events;
    } else {
      return events.where((event) => event.category == filterCategory).toList();
    }
  }

  Widget _imagePickerWidget() {
    return Column(
      children: [
        _selectedImage != null
            ? Image.file(_selectedImage!, height: 150)
            : const Text('No Image Selected'),
        ElevatedButton(
          onPressed: _pickImage,
          child: const Text('Pick Image'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Events & Blogs'),
        backgroundColor: Colors.red.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Filter: ', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: filterCategory,
                  onChanged: (value) {
                    setState(() {
                      filterCategory = value!;
                    });
                  },
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All')),
                    DropdownMenuItem(value: 'Event', child: Text('Events')),
                    DropdownMenuItem(value: 'Blog', child: Text('Blogs')),
                  ],
                ),
              ],
            ),
            const Divider(height: 30),

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                const Text('Select Type: ', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  items: const [
                    DropdownMenuItem(value: 'Event', child: Text('Event')),
                    DropdownMenuItem(value: 'Blog', child: Text('Blog')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: Text('Pick Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white),
            ),
            const SizedBox(height: 10),

            _imagePickerWidget(),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: _addEvent,
              child: const Text('Publish Event/Blog'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            ),

            const SizedBox(height: 20),
            const Divider(),
            const Text('Published Events/Blogs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            Expanded(
              child: ListView.builder(
                itemCount: filteredEvents.length,
                itemBuilder: (context, index) {
                  final event = filteredEvents[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: event.imageUrl != null
                          ? Image.network(
                              event.imageUrl!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              event.category == 'Event' ? Icons.event : Icons.article,
                              color: Colors.red.shade700,
                            ),
                      title: Text(event.title),
                      subtitle: Text('${event.description}\n${event.date.day}/${event.date.month}/${event.date.year}'),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteEvent(event.id!),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Event {
  final String? id;
  final String title;
  final String description;
  final DateTime date;
  final String category;
  final String? imageUrl;

  Event({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    this.imageUrl,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      category: json['category'],
      imageUrl: json['imageUrl'],
    );
  }
}
