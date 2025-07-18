import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

class Invoice {
  final String userName;
  final String status;
  final double amount;
  final DateTime dueDate;

  Invoice({
    required this.userName,
    required this.status,
    required this.amount,
    required this.dueDate,
  });
}

class InvoicingPage extends StatefulWidget {
  const InvoicingPage({super.key});

  @override
  State<InvoicingPage> createState() => _InvoicingPageState();
}

class _InvoicingPageState extends State<InvoicingPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Invoice> invoices = [
    Invoice(userName: 'User A', status: 'Pending', amount: 150.0, dueDate: DateTime.now().add(const Duration(days: 5))),
    Invoice(userName: 'User B', status: 'Completed', amount: 200.0, dueDate: DateTime.now().subtract(const Duration(days: 3))),
    Invoice(userName: 'User C', status: 'Pending', amount: 300.0, dueDate: DateTime.now().add(const Duration(days: 2))),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void downloadInvoice(Invoice invoice) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text('Invoice for ${invoice.userName}\nAmount: \$${invoice.amount}\nStatus: ${invoice.status}\nDue: ${invoice.dueDate}'),
        ),
      ),
    );
    // await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  void sendPaymentReminder(Invoice invoice) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reminder sent to ${invoice.userName} for payment.')),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Invoice> pendingInvoices = invoices.where((inv) => inv.status == 'Pending').toList();
    List<Invoice> completedInvoices = invoices.where((inv) => inv.status == 'Completed').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoicing'),
        backgroundColor: Colors.red.shade700,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Completed'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInvoiceList(pendingInvoices),
          _buildInvoiceList(completedInvoices),
          _buildInvoiceList(invoices),
        ],
      ),
    );
  }

  Widget _buildInvoiceList(List<Invoice> invoiceList) {
    return ListView.builder(
      itemCount: invoiceList.length,
      itemBuilder: (context, index) {
        final invoice = invoiceList[index];
        return Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            title: Text('${invoice.userName} - \$${invoice.amount}'),
            subtitle: Text('Due: ${invoice.dueDate.day}/${invoice.dueDate.month}/${invoice.dueDate.year} - Status: ${invoice.status}'),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'Download Invoice') {
                  downloadInvoice(invoice);
                } else if (value == 'Send Reminder') {
                  sendPaymentReminder(invoice);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'Download Invoice', child: Text('Download PDF')),
                const PopupMenuItem(value: 'Send Reminder', child: Text('Send Payment Reminder')),
              ],
            ),
          ),
        );
      },
    );
  }
}
