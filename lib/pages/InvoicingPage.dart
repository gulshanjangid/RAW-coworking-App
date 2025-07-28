// user_invoice_page.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Invoice {
  final String id;
  final double amount;
  final String status;
  final String? paymentImage;
  final DateTime createdAt;

  Invoice({
    required this.id,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.paymentImage,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['_id'],
      amount: (json['price'] as num).toDouble(),
      status: json['status'],
      paymentImage: json['paymentImage'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class UserInvoicePage extends StatefulWidget {
  final String token;
  const UserInvoicePage({super.key, required this.token});

  @override
  State<UserInvoicePage> createState() => _UserInvoicePageState();
}

class _UserInvoicePageState extends State<UserInvoicePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Invoice> invoices = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchInvoices();
  }

  Future<void> fetchInvoices() async {
    try {
      final url = Uri.parse(
          'https://raw-coworking-app.onrender.com/api/invoices/user/${widget.token}');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
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
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> uploadPaymentImage(String invoiceId) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://raw-coworking-app.onrender.com/api/invoices/pay/$invoiceId'),
    );
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    final response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment submitted.')),
      );
      fetchInvoices();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload failed')),
      );
    }
  }

  Future<void> rejectInvoice(String invoiceId) async {
    final res = await http.post(
      Uri.parse('https://raw-coworking-app.onrender.com/api/invoices/reject/$invoiceId'),
    );
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice rejected')),
      );
      fetchInvoices();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to reject')),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pending = invoices.where((i) => i.status == 'pending').toList();
    final paid = invoices.where((i) => i.status == 'paid').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Invoices'),
        backgroundColor: Colors.red.shade700,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Paid'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                buildInvoiceList(pending),
                buildInvoiceList(paid),
              ],
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
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          elevation: 3,
          child: ListTile(
            leading: const Icon(Icons.receipt_long),
            title: Text('Amount: ₹${invoice.amount.toStringAsFixed(2)}'),
            subtitle: Text(
                'Status: ${invoice.status}\nDate: ${invoice.createdAt.toLocal()}'),
            trailing: invoice.status == 'pending'
                ? PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'Pay') {
                        uploadPaymentImage(invoice.id);
                      } else if (value == 'Reject') {
                        rejectInvoice(invoice.id);
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'Pay', child: Text('Submit Payment')),
                      PopupMenuItem(value: 'Reject', child: Text('Reject Invoice')),
                    ],
                  )
                : invoice.paymentImage != null
                    ? IconButton(
                        icon: const Icon(Icons.image),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Payment Proof'),
                              content: Image.network(
                                'https://raw-coworking-app.onrender.com/uploads/${invoice.paymentImage}',
                                errorBuilder: (_, __, ___) =>
                                    const Text('Image not found'),
                              ),
                            ),
                          );
                        },
                      )
                    : const Icon(Icons.check_circle, color: Colors.green),
          ),
        );
      },
    );
  }
}
