import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'meeting_schedule.dart'; // ✅ Import meeting schedule screen

class ServicePage extends StatefulWidget {
  final String token;
  const ServicePage({super.key, required this.token});
  

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<ServiceRequest> requests = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchMyServiceRequests();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> fetchMyServiceRequests() async {
    final url = Uri.parse('http://10.0.2.2:8080/api/requests/my');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          requests.clear();
          requests.addAll(data.map((item) => ServiceRequest(
            title: item['title'],
            description: item['description'],
            status: item['status'] ?? 'Pending',
            createdAt: DateTime.parse(item['createdAt']),
          )));
        });
      } else {
        print('Failed to fetch requests: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching requests: $e');
    }
  }

  void addServiceRequest() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and Description are required')),
      );
      return;
    }

    final url = Uri.parse('http://10.0.2.2:8080/api/requests/create');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'title': title,
          'description': description,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _titleController.clear();
        _descriptionController.clear();

        await fetchMyServiceRequests();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service Request Created')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${response.statusCode} - ${response.body}')),
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
      appBar: AppBar(
        title: const Text('User Services & Meetings'),
        backgroundColor: Colors.red.shade700,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          tabs: const [
            Tab(text: 'Create Request'),
            Tab(text: 'My Requests'),
            Tab(text: 'Meetings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Service/Complaint Title', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: addServiceRequest,
                  icon: const Icon(Icons.add),
                  label: const Text('Submit Request'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white),
                ),
              ],
            ),
          ),

          RefreshIndicator(
            onRefresh: fetchMyServiceRequests,
            child: requests.isEmpty
                ? const Center(child: Text('No service requests yet.', style: TextStyle(fontSize: 16)))
                : ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final request = requests[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        elevation: 3,
                        child: ListTile(
                          leading: Icon(Icons.assignment, color: Colors.red.shade700),
                          title: Text(request.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(request.description),
                              const SizedBox(height: 4),
                              Text('Status: ${request.status}', style: const TextStyle(color: Colors.grey)),
                              Text('Created: ${request.createdAt.day}/${request.createdAt.month}/${request.createdAt.year}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // ✅ Meetings Tab replaced with external screen
          MeetingSchedule(token: widget.token),
        ],
      ),
    );
  }
}

class ServiceRequest {
  final String title;
  final String description;
  final String status;
  final DateTime createdAt;

  ServiceRequest({
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
  });
}
