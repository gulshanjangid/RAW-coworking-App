const mongoose = require('mongoose');

const invoiceSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  price: Number,
  status: { type: String, enum: ['pending', 'paid', 'rejected'], default: 'pending' },
  paymentImage: String, // Image path
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Invoice', invoiceSchema);
