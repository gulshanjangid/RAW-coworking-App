import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MeetingRoomPage extends StatefulWidget {
  final String token;

  const MeetingRoomPage({
    super.key,
    required this.token,
  });

  @override
  State<MeetingRoomPage> createState() => _MeetingRoomPageState();
}

class _MeetingRoomPageState extends State<MeetingRoomPage> {
  String? _selectedLocation;
  DateTime? _selectedDate;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final List<String> locations = [
    'RAW Vaishali Nagar First Floor Meeting Room',
    'RAW New Aatish Market Second Floor Meeting Room',
    'RAW New Aatish Market First Floor Conference Room',
    'RAW Malviya Nagar Studio 8',
    'RAW Malviya Nagar Studio 6',
  ];

  final List<String> allTimeSlots = [
    '09:00 - 09:30', '09:30 - 10:00',
    '10:00 - 10:30', '10:30 - 11:00',
    '11:00 - 11:30', '11:30 - 12:00',
    '12:00 - 12:30', '12:30 - 13:00',
    '13:00 - 13:30', '13:30 - 14:00',
    '14:00 - 14:30', '14:30 - 15:00',
    '15:00 - 15:30', '15:30 - 16:00',
    '16:00 - 16:30', '16:30 - 17:00',
    '17:00 - 17:30', '17:30 - 18:00',
    '18:00 - 18:30', '18:30 - 19:00',
    '19:00 - 19:30', '19:30 - 20:00',
    '20:00 - 20:30', '20:30 - 21:00',
  ];

  List<String> selectedSlots = [];
  Map<String, List<String>> bookedSlots = {};

  void _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
      selectableDayPredicate: (DateTime day) => day.weekday != DateTime.sunday,
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        selectedSlots.clear();
      });
    }
  }

  void _toggleSlot(String slot) {
    setState(() {
      if (selectedSlots.contains(slot)) {
        selectedSlots.remove(slot);
      } else {
        if (selectedSlots.length >= 4) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You can only book up to 4 slots per day')),
          );
        } else {
          selectedSlots.add(slot);
        }
      }
    });
  }

  bool isSlotInPast(String slot) {
    if (_selectedDate == null) return false;

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime selected = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day);

    if (selected.isAtSameMomentAs(today)) {
      String endTimeString = slot.split('-')[1].trim();
      DateTime slotEndTime = DateFormat('HH:mm').parse(endTimeString);
      DateTime slotEndDateTime = DateTime(now.year, now.month, now.day, slotEndTime.hour, slotEndTime.minute);
      return now.isAfter(slotEndDateTime);
    }
    return false;
  }

  void _handleSubmit() async {
    if (_selectedLocation == null ||
        _nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _selectedDate == null ||
        selectedSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select at least one slot')),
      );
      return;
    }

    String dateKey = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    bookedSlots.putIfAbsent(dateKey, () => []);
    bookedSlots[dateKey]!.addAll(selectedSlots);

    final bookingData = {
      "username": "flutter_user", // Replace with real username if needed
      "location": _selectedLocation!,
      "date": dateKey,
      "timeSlot": selectedSlots.join(', '),
      "name": _nameController.text,
      "phone": _phoneController.text,
      "price": 600 * selectedSlots.length,
    };

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/meetings/book-meeting'), // TODO: Replace with your actual backend URL
        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}'}, // Include token for authentication
        body: jsonEncode(bookingData),
      );

      if (response.statusCode == 201) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Thank You for Booking!',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('📍 Location: $_selectedLocation'),
                    const SizedBox(height: 8),
                    const Text('🛠️ Service: Meeting Room'),
                    const SizedBox(height: 8),
                    Text('👤 Name: ${_nameController.text}'),
                    const SizedBox(height: 8),
                    Text('📞 Phone: ${_phoneController.text}'),
                    const SizedBox(height: 8),
                    const Text('💰 Price: ₹600 per slot'),
                    const SizedBox(height: 8),
                    Text('📅 Date: ${DateFormat.yMMMd().format(_selectedDate!)}'),
                    const SizedBox(height: 8),
                    Text('🕑 Slots: ${selectedSlots.join(', ')}'),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _clearForm();
                          },
                          child: const Text('Book New Appointment'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking failed: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _clearForm() {
    setState(() {
      _selectedLocation = null;
      _selectedDate = null;
      selectedSlots.clear();
      _nameController.clear();
      _phoneController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    String dateKey = _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : '';
    List<String> bookedToday = bookedSlots[dateKey] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Your Meeting Room'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Please Enter Details',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            DropdownButtonFormField<String>(
              value: _selectedLocation,
              decoration: InputDecoration(
                labelText: 'Select Location',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              isExpanded: true,
              items: locations.map((location) {
                return DropdownMenuItem(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLocation = value;
                  _selectedDate = null;
                  selectedSlots.clear();
                });
              },
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _selectDate,
              child: Text(
                _selectedDate == null
                    ? 'Select Date (within 7 days)'
                    : DateFormat.yMMMd().format(_selectedDate!),
              ),
            ),
            const SizedBox(height: 16),

            if (_selectedDate != null) ...[
              const Text(
                'Select Time Slots (Max 4 slots)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 3,
                ),
                itemCount: allTimeSlots.length,
                itemBuilder: (context, index) {
                  String slot = allTimeSlots[index];
                  bool isBooked = bookedToday.contains(slot);
                  bool isPast = isSlotInPast(slot);
                  bool isSelected = selectedSlots.contains(slot);

                  return GestureDetector(
                    onTap: (isBooked || isPast) ? null : () => _toggleSlot(slot),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isBooked
                            ? Colors.grey
                            : isPast
                                ? Colors.redAccent
                                : isSelected
                                    ? Colors.blue
                                    : Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        slot,
                        style: TextStyle(
                          color: (isBooked || isPast) ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],

            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
