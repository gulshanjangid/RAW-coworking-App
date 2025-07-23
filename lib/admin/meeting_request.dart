import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MeetingRequest extends StatefulWidget {
  final String adminId;
  const MeetingRequest({required this.adminId});

  @override
  _MeetingRequestState createState() => _MeetingRequestState();
}

class _MeetingRequestState extends State<MeetingRequest> {
  List meetings = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchPendingMeetings();
  }

  Future<void> fetchPendingMeetings() async {
    setState(() => isLoading = true);
    final res = await http.get(Uri.parse('https://raw-coworking-app.onrender.com/api/meet_schedule/pending'));
    if (res.statusCode == 200) {
      meetings = jsonDecode(res.body);
    }
    setState(() => isLoading = false);
  }

  Future<void> approveMeeting(String meetingId) async {
    final meetingLink = 'https://meet.jit.si/$meetingId';
    final res = await http.post(
      Uri.parse('https://raw-coworking-app.onrender.com/api/meet_schedule/approve'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'meetingId': meetingId,
        'adminId': widget.adminId,
        'meetingLink': meetingLink,
      }),
    );
    if (res.statusCode == 200) {
      fetchPendingMeetings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Meeting Requests')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: meetings.length,
              itemBuilder: (ctx, i) {
                final m = meetings[i];
                final dt = DateTime.parse(m['datetime']).toLocal();
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('User ID: ${m['userId']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}'),
                        Text('Requested At: ${DateTime.parse(m['createdAt']).toLocal()}'),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => approveMeeting(m['_id']),
                      child: const Text('Approve'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
