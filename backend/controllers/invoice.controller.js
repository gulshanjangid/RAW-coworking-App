const Invoice = require('../models/Invoice');
const User = require('../models/User');

// Admin: Create invoice
exports.createInvoice = async (req, res) => {
  const { username, price } = req.body;

  const user = await User.findOne({ username });
  if (!user) return res.status(404).json({ message: 'User not found' });

  const invoice = new Invoice({ user: user._id, price });
  await invoice.save();

  res.status(201).json(invoice);
};

// User: Get invoices
exports.getUserInvoices = async (req, res) => {
  const { username } = req.params;

  const user = await User.findOne({ username });
  if (!user) return res.status(404).json({ message: 'User not found' });

  const invoices = await Invoice.find({ user: user._id }).populate('user');
  res.json(invoices);
};

// User: Submit payment image
exports.uploadPaymentImage = async (req, res) => {
  const { invoiceId } = req.params;
  const image = req.file?.filename;

  const invoice = await Invoice.findByIdAndUpdate(
    invoiceId,
    { paymentImage: image, status: 'paid' },
    { new: true }
  );

  res.json(invoice);
};

// User: Reject invoice (if clicked "No")
exports.rejectInvoice = async (req, res) => {
  const { invoiceId } = req.params;

  const invoice = await Invoice.findByIdAndUpdate(
    invoiceId,
    { status: 'rejected' },
    { new: true }
  );

  res.json(invoice);
};
