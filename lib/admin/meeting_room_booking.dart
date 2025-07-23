import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MeetingRoomAdminPage extends StatefulWidget {
  const MeetingRoomAdminPage({super.key});

  @override
  State<MeetingRoomAdminPage> createState() => _MeetingRoomAdminPageState();
}

class _MeetingRoomAdminPageState extends State<MeetingRoomAdminPage> {
  List<MeetingRoomBooking> bookings = [];
  List<MeetingRoomBooking> filteredBookings = [];
  String searchQuery = '';
  String? selectedDate; 

  @override
  void initState() {
    super.initState();
    fetchMeetingBookings();
  }

  Future<void> fetchMeetingBookings() async {
    final url = Uri.parse('https://raw-coworking-app.onrender.com/meetings/meetings');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final fetchedBookings = data
            .map((item) => MeetingRoomBooking.fromJson(item))
            .toList();

        fetchedBookings.sort((a, b) =>
            DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));

        setState(() {
          bookings = fetchedBookings;
          applyFilter();
        });
      } else {
        print('Failed to fetch bookings: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching meetings: $e');
    }
  }

  void applyFilter() {
    setState(() {
      filteredBookings = bookings.where((booking) {
        final query = searchQuery.toLowerCase();
        final matchesSearch = booking.username.toLowerCase().contains(query) ||
            booking.date.toLowerCase().contains(query);

        final matchesDate = selectedDate == null
            ? true
            : booking.date == selectedDate;

        return matchesSearch && matchesDate;
      }).toList();
    });
  }

  Future<void> pickDateFilter() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate.toIso8601String().split('T')[0];
      });
      applyFilter();
    }
  }

  void clearDateFilter() {
    setState(() {
      selectedDate = null;
    });
    applyFilter();
  }

  Future<void> deleteBooking(String id) async {
    final url = Uri.parse('https://raw-coworking-app.onrender.com/meetings/delete-meeting/$id');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking deleted')),
        );
        fetchMeetingBookings();
      } else {
        print('Failed to delete booking');
      }
    } catch (e) {
      print('Error deleting booking: $e');
    }
  }

  Future<void> updateBooking(MeetingRoomBooking booking) async {
    final url = Uri.parse('https://raw-coworking-app.onrender.com/meetings/update-meeting/${booking.id}');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': booking.name,
          'phone': booking.phone,
          'location': booking.location,
          'date': booking.date,
          'timeSlot': booking.timeSlot,
          'price': booking.price,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking updated')),
        );
        fetchMeetingBookings();
      } else {
        print('Failed to update booking');
      }
    } catch (e) {
      print('Error updating booking: $e');
    }
  }

  void editBookingDialog(MeetingRoomBooking booking) {
    final nameController = TextEditingController(text: booking.name);
    final phoneController = TextEditingController(text: booking.phone);
    final dateController = TextEditingController(text: booking.date);
    final timeSlotController = TextEditingController(text: booking.timeSlot);
    final priceController = TextEditingController(text: booking.price.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Booking'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone')),
              TextField(controller: dateController, decoration: const InputDecoration(labelText: 'Date')),
              TextField(controller: timeSlotController, decoration: const InputDecoration(labelText: 'Time Slot')),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final updated = booking.copyWith(
                name: nameController.text,
                phone: phoneController.text,
                date: dateController.text,
                timeSlot: timeSlotController.text,
                price: int.tryParse(priceController.text) ?? booking.price,
              );
              Navigator.pop(context);
              updateBooking(updated);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting Room Bookings'),
        backgroundColor: const Color.fromARGB(255, 206, 46, 2),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchMeetingBookings,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by username or date (YYYY-MM-DD)',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                searchQuery = value;
                applyFilter();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.date_range),
                    label: Text(selectedDate == null
                        ? 'Filter by Date'
                        : 'Date: $selectedDate'),
                    onPressed: pickDateFilter,
                  ),
                ),
                if (selectedDate != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: clearDateFilter,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: filteredBookings.isEmpty
                ? const Center(child: Text('No bookings found'))
                : RefreshIndicator(
                    onRefresh: fetchMeetingBookings,
                    child: ListView.builder(
                      itemCount: filteredBookings.length,
                      itemBuilder: (context, index) {
                        final booking = filteredBookings[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: ListTile(
                            leading: const Icon(Icons.meeting_room, color: Colors.purple),
                            title: Text(booking.username),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Name: ${booking.name}'),
                                Text('Phone: ${booking.phone}'),
                                Text('Location: ${booking.location}'),
                                Text('Date: ${booking.date}'),
                                Text('Time Slot: ${booking.timeSlot}'),
                                Text('Price: ₹${booking.price}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => editBookingDialog(booking),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => deleteBooking(booking.id),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class MeetingRoomBooking {
  final String id;
  final String username;
  final String name;
  final String phone;
  final String location;
  final String date;
  final String timeSlot;
  final int price;

  MeetingRoomBooking({
    required this.id,
    required this.username,
    required this.name,
    required this.phone,
    required this.location,
    required this.date,
    required this.timeSlot,
    required this.price,
  });

  factory MeetingRoomBooking.fromJson(Map<String, dynamic> json) {
    return MeetingRoomBooking(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] ?? '',
      date: json['date'] ?? '',
      timeSlot: json['timeSlot'] ?? '',
      price: json['price'] ?? 0,
    );
  }

  MeetingRoomBooking copyWith({
    String? name,
    String? phone,
    String? date,
    String? timeSlot,
    int? price,
  }) {
    return MeetingRoomBooking(
      id: id,
      username: username,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      location: location,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      price: price ?? this.price,
    );
  }
}
