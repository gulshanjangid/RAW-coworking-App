import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MeetingSchedule extends StatefulWidget {
  final String token;
    const MeetingSchedule({super.key, required this.token});
  @override
  _MeetingScheduleState createState() => _MeetingScheduleState();
}

class _MeetingScheduleState extends State<MeetingSchedule> {
  List meetings = [];
  bool isLoading = false;

  DateTime? selectedDateTime;

  @override
  void initState() {
    super.initState();
    fetchMeetings();
  }

  Future<void> fetchMeetings() async {
    setState(() => isLoading = true);
    final url = Uri.parse('https://raw-coworking-app.onrender.com/api/meet_schedule/user');
    final res = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );

    if (res.statusCode == 200) {
      meetings = jsonDecode(res.body);
    } else {
      meetings = [];
    }

    setState(() => isLoading = false);
  }

  Future<void> scheduleMeeting() async {
    if (selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date and time')),
      );
      return;
    }

    final url = Uri.parse('https://raw-coworking-app.onrender.com/api/meet_schedule/request');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({'datetime': selectedDateTime!.toIso8601String()}),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meeting requested successfully')),
      );
      fetchMeetings();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to request meeting')),
      );
    }
  }

  Future<void> selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule Meeting (Offline)')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: selectDateTime,
                  child: const Text('Select Date & Time'),
                ),
                if (selectedDateTime != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Selected: ${selectedDateTime!.toLocal()}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ElevatedButton(
                  onPressed: scheduleMeeting,
                  child: const Text('Submit Meeting Request'),
                ),
                const Divider(),
                const SizedBox(height: 10),
                const Text('Your Meetings:', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: meetings.length,
                    itemBuilder: (ctx, i) {
                      final m = meetings[i];
                      final DateTime dt = DateTime.parse(m['datetime']).toLocal();
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Text('Date: ${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Status: ${m['status']}'),
                              if (m['adminId'] != null)
                                Text('Approved By Manager: ${m['adminId']}'),
                              if (m['createdAt'] != null)
                                Text('Requested On: ${DateTime.parse(m['createdAt']).toLocal()}'),
                            ],
                          ),
                          trailing: Text(
                            m['status'] == 'approved' ? 'Approved' : 'Pending',
                            style: TextStyle(
                              color: m['status'] == 'approved'
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
