const mongoose = require('mongoose');

const invoiceSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  price: { type: Number, required: true },
  status: { type: String, enum: ['pending', 'paid', 'rejected'], default: 'pending' },
  paymentImage: { type: String, default: null }
}, { timestamps: true });

module.exports = mongoose.model('Invoice', invoiceSchema);
