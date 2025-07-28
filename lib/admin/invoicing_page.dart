// admin_invoicing_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Invoice {
  final String id;
  final String username;
  final String? email;
  final double price;
  final String status;
  final String? paymentImage;

  Invoice({
    required this.id,
    required this.username,
    this.email,
    required this.price,
    required this.status,
    this.paymentImage,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};
    return Invoice(
      id: json['_id'],
      username: user['username'] ?? 'Unknown',
      email: user['email'],
      price: (json['price'] as num).toDouble(),
      status: json['status'],
      paymentImage: json['paymentImage'],
    );
  }
}

class AdminInvoicingPage extends StatefulWidget {
  const AdminInvoicingPage({super.key});

  @override
  State<AdminInvoicingPage> createState() => _AdminInvoicingPageState();
}

class _AdminInvoicingPageState extends State<AdminInvoicingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Invoice> invoices = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchInvoices();
  }

  Future<void> fetchInvoices() async {
    try {
      final res = await http.get(
        Uri.parse('https://raw-coworking-app.onrender.com/api/invoices/all'),
      );
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        setState(() {
          invoices = data.map((e) => Invoice.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load invoices');
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching invoices: $e')),
      );
    }
  }

  Future<void> createInvoice(String username, double price) async {
    try {
      final res = await http.post(
        Uri.parse('https://raw-coworking-app.onrender.com/api/invoices/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'price': price}),
      );
      if (res.statusCode == 201) {
        fetchInvoices();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invoice created.')),
        );
      } else {
        throw Exception('Failed to create invoice');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _showCreateInvoiceDialog() {
    final usernameController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Invoice'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: usernameController, decoration: const InputDecoration(labelText: 'Username')),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final username = usernameController.text.trim();
              final price = double.tryParse(priceController.text.trim()) ?? 0.0;
              if (username.isNotEmpty && price > 0) {
                Navigator.pop(context);
                createInvoice(username, price);
              }
            },
            child: const Text('Create'),
          )
        ],
      ),
    );
  }

  List<Invoice> filterInvoices(String status) {
    return invoices.where((inv) => inv.status.toLowerCase() == status.toLowerCase()).toList();
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
        title: const Text('Admin Invoicing'),
        backgroundColor: Colors.red.shade700,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Paid'),
            Tab(text: 'All'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                buildInvoiceList(filterInvoices('pending')),
                buildInvoiceList(filterInvoices('paid')),
                buildInvoiceList(invoices),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red.shade700,
        onPressed: _showCreateInvoiceDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildInvoiceList(List<Invoice> list) {
    if (list.isEmpty) {
      return const Center(child: Text('No invoices'));
    }

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final invoice = list[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.account_circle, size: 36),
            title: Text('${invoice.username} — ₹${invoice.price.toStringAsFixed(2)}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (invoice.email != null) Text('Email: ${invoice.email}'),
                Text('Status: ${invoice.status}'),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'Reminder') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Reminder sent to ${invoice.username}')),
                  );
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'Reminder', child: Text('Send Reminder')),
              ],
            ),
          ),
        );
      },
    );
  }
}
