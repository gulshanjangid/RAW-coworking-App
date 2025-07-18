import 'package:flutter/material.dart';

class SendRemindersPage extends StatefulWidget {
  const SendRemindersPage({super.key});

  @override
  State<SendRemindersPage> createState() => _SendRemindersPageState();
}

class _SendRemindersPageState extends State<SendRemindersPage> {
  final List<String> users = ['User A', 'User B', 'User C'];
  final List<String> channels = ['WhatsApp', 'Email'];

  void sendReminder(String user, String channel) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reminder sent to $user via $channel.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Reminders'),
        backgroundColor: Colors.red.shade700,
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(user),
              subtitle: const Text('Select reminder channel'),
              trailing: PopupMenuButton<String>(
                onSelected: (channel) => sendReminder(user, channel),
                itemBuilder: (context) => channels.map((channel) {
                  return PopupMenuItem<String>(
                    value: channel,
                    child: Text(channel),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
