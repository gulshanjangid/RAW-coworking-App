import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ✅ Import your meeting screen here
import 'meeting_request.dart';

class ComplaintsMeetingsPage extends StatefulWidget {
  const ComplaintsMeetingsPage({super.key});

  @override
  State<ComplaintsMeetingsPage> createState() => _ComplaintsMeetingsPageState();
}

class _ComplaintsMeetingsPageState extends State<ComplaintsMeetingsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ServiceRequest> complaints = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchAllComplaints();
  }

  /// ✅ Fetch all complaints (admin, no token)
  Future<void> fetchAllComplaints() async {
    final url = Uri.parse('https://raw-coworking-backend.onrender.com/api/requests/all');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          complaints = data.map((item) => ServiceRequest(
            id: item['_id'] ?? '',
            title: item['title'] ?? '',
            description: item['description'] ?? '',
            status: item['status'] ?? 'Pending',
            createdAt: DateTime.tryParse(item['createdAt'] ?? '') ?? DateTime.now(),
            username: item['username'] ?? 'Unknown User',
          )).toList();
        });
      } else {
        print('Failed to load complaints: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching complaints: $e');
    }
  }

  /// ✅ Update complaint status (PUT API)
  Future<void> updateComplaintStatus(String complaintId, String newStatus) async {
    final url = Uri.parse('https://raw-coworking-backend.onrender.com/api/requests/$complaintId/status');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': newStatus}),
      );
      if (response.statusCode == 200) {
        setState(() {
          final index = complaints.indexWhere((c) => c.id == complaintId);
          if (index != -1) {
            complaints[index].status = newStatus;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status updated to $newStatus')),
        );
      } else {
        print('Failed to update status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaints & Meetings'),
        backgroundColor: Colors.red.shade700,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Complaints'),
            Tab(text: 'Upcoming Meetings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 🔴 Complaints Tab
          complaints.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: fetchAllComplaints,
                  child: ListView.builder(
                    itemCount: complaints.length,
                    itemBuilder: (context, index) {
                      final complaint = complaints[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.report_problem, color: Colors.red),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${complaint.username}: ${complaint.title}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(complaint.description),
                              const SizedBox(height: 6),
                              Text('Status: ${complaint.status}', style: const TextStyle(color: Colors.grey)),
                              Text(
                                'Date: ${complaint.createdAt.day}/${complaint.createdAt.month}/${complaint.createdAt.year}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  if (complaint.status != 'Pending')
                                    ElevatedButton(
                                      onPressed: () => updateComplaintStatus(complaint.id, 'Pending'),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                                      child: const Text('Mark Pending'),
                                    ),
                                  const SizedBox(width: 8),
                                  if (complaint.status != 'Resolved')
                                    ElevatedButton(
                                      onPressed: () => updateComplaintStatus(complaint.id, 'Resolved'),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                      child: const Text('Mark Resolved'),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

          // 🟢 Meetings Tab replaced with meeting_request.dart screen
          const MeetingRequest(
            adminId: 'admin123',
            
          ),
        ],
      ),
    );
  }
}

// ✅ Model class
class ServiceRequest {
  final String id;
  final String title;
  final String description;
  String status;
  final DateTime createdAt;
  final String username;

  ServiceRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.username,
  });
}
