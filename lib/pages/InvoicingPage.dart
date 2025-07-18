import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class InvoicingPage extends StatefulWidget {
  const InvoicingPage({super.key});

  @override
  State<InvoicingPage> createState() => _InvoicingPageState();
}

class _InvoicingPageState extends State<InvoicingPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Invoice> invoices = [
    Invoice(
      id: 'INV001',
      description: 'Community Service Fee',
      amount: 150.00,
      status: 'Pending',
      dueDate: DateTime.now().add(const Duration(days: 3)),
    ),
    Invoice(
      id: 'INV002',
      description: 'Monthly Subscription',
      amount: 50.00,
      status: 'Pending',
      dueDate: DateTime.now().subtract(const Duration(days: 2)), // Overdue
    ),
    Invoice(
      id: 'INV003',
      description: 'Event Participation',
      amount: 100.00,
      status: 'Paid',
      dueDate: DateTime.now(),
    ),
  ];

  String selectedPaymentMethod = 'Card';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void processPayment(Invoice invoice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Processing Payment'),
        content: const SizedBox(height: 80, child: Center(child: CircularProgressIndicator())),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      setState(() {
        invoice.status = 'Paid';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Successful. Email confirmation sent for ${invoice.id}')),
      );
    });
  }

  Future<void> downloadPDF(Invoice invoice) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Invoice ID: ${invoice.id}', style: pw.TextStyle(fontSize: 20)),
              pw.SizedBox(height: 10),
              pw.Text('Description: ${invoice.description}'),
              pw.Text('Amount: \$${invoice.amount.toStringAsFixed(2)}'),
              pw.Text('Due Date: ${DateFormat('dd/MM/yyyy').format(invoice.dueDate)}'),
              pw.Text('Status: ${invoice.status}'),
            ],
          ),
        ),
      ),
    );
    // await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  bool isOverdue(Invoice invoice) {
    return invoice.dueDate.isBefore(DateTime.now()) && invoice.status == 'Pending';
  }

  String getDueStatus(Invoice invoice) {
    if (invoice.status == 'Paid') return 'Paid';
    final difference = invoice.dueDate.difference(DateTime.now()).inDays;
    if (difference < 0) return 'Overdue by ${-difference} days';
    return '$difference days left';
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
        title: const Text('Invoices & Payments'),
        backgroundColor: Colors.red.shade700,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          tabs: const [
            Tab(text: 'Pending Payments'),
            Tab(text: 'Paid Invoices'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildInvoiceList('Pending'),
          buildInvoiceList('Paid'),
        ],
      ),
    );
  }

  Widget buildInvoiceList(String status) {
    final filteredInvoices = invoices.where((invoice) => invoice.status == status).toList();

    if (filteredInvoices.isEmpty) {
      return const Center(
        child: Text('No invoices found.', style: TextStyle(fontSize: 16, color: Colors.grey)),
      );
    }

    return ListView.builder(
      itemCount: filteredInvoices.length,
      itemBuilder: (context, index) {
        final invoice = filteredInvoices[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          elevation: 3,
          child: ListTile(
            leading: Icon(Icons.receipt_long, color: Colors.red.shade700),
            title: Text(invoice.description),
            subtitle: Text('Invoice ID: ${invoice.id}\nAmount: \$${invoice.amount.toStringAsFixed(2)}\nDue: ${getDueStatus(invoice)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.download, color: Colors.blue),
                  onPressed: () => downloadPDF(invoice),
                ),
                invoice.status == 'Pending'
                    ? ElevatedButton(
                        onPressed: () => showPaymentBottomSheet(invoice),
                        child: const Text('Pay Now'),
                        style: ElevatedButton.styleFrom(backgroundColor: isOverdue(invoice) ? Colors.orange : Colors.green),
                      )
                    : const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
          ),
        );
      },
    );
  }

  void showPaymentBottomSheet(Invoice invoice) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Pay Invoice: ${invoice.id}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Select Payment Method: ', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value!;
                    });
                    Navigator.pop(context);
                    showPaymentBottomSheet(invoice);
                  },
                  items: const [
                    DropdownMenuItem(value: 'Card', child: Text('Card')),
                    DropdownMenuItem(value: 'UPI', child: Text('UPI')),
                    DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                processPayment(invoice);
              },
              icon: const Icon(Icons.payment),
              label: const Text('Proceed to Pay'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class Invoice {
  final String id;
  final String description;
  final double amount;
  String status;
  final DateTime dueDate;

  Invoice({
    required this.id,
    required this.description,
    required this.amount,
    required this.status,
    required this.dueDate,
  });
}
