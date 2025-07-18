import 'package:flutter/material.dart';
import 'new_user.dart';
import 'current_users.dart';
import 'event_manage.dart';
import 'complaints_meetings.dart';
import 'invoicing_page.dart';
import 'send_reminders.dart';
import 'meeting_room_booking.dart'; // ✅ Add this import

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    final List<_DashboardItem> dashboardItems = [
      _DashboardItem('Manage Users', Icons.people, const ManageUsersPage()),
      _DashboardItem('Manage Events', Icons.event, const ManageEventsPage()),
      _DashboardItem('Complaints / Meetings', Icons.support_agent, const ComplaintsMeetingsPage()),
      _DashboardItem('Invoicing', Icons.payment, const InvoicingPage()),
      _DashboardItem('Send Reminders', Icons.notifications_active, const SendRemindersPage()),
      _DashboardItem('Meeting Room Booking', Icons.meeting_room, const MeetingRoomAdminPage()), // ✅ New Grid Item
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.red.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: dashboardItems.length,
          itemBuilder: (context, index) {
            final item = dashboardItems[index];
            return GestureDetector(
              onTap: () => _navigateTo(context, item.page),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Colors.red.shade100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.icon, size: 50, color: Colors.red.shade700),
                    const SizedBox(height: 10),
                    Text(item.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DashboardItem {
  final String title;
  final IconData icon;
  final Widget page;

  _DashboardItem(this.title, this.icon, this.page);
}

// Manage Users with Tabs
class ManageUsersPage extends StatelessWidget {
  const ManageUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Users'),
          bottom: const TabBar(tabs: [
            Tab(text: 'New Users'),
            Tab(text: 'Current Users'),
          ]),
          backgroundColor: Colors.red.shade700,
        ),
        body: const TabBarView(
          children: [
            NewUser(),
            CurrentUsers(),
          ],
        ),
      ),
    );
  }
}

// Manage Events with Tabs
class ManageEventsPage extends StatelessWidget {
  const ManageEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Events'),
          bottom: const TabBar(tabs: [
            Tab(text: 'Events'),
            Tab(text: 'Blogs'),
          ]),
          backgroundColor: Colors.red.shade700,
        ),
        body: const TabBarView(
          children: [
            EventManage(),
            Center(child: Text('Blog Management Section')),
          ],
        ),
      ),
    );
  }
}
