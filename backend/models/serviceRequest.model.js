const mongoose = require('mongoose');

const serviceRequestSchema = new mongoose.Schema({
  username: { type: String, required: true },
  title: { type: String, required: true },
  description: { type: String, required: true },
  officeLocation: { type: String, required: true },
  seatNumber: { type: String, required: true },  // Fetched from user's record
  status: { type: String, default: 'Pending' },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('ServiceRequest', serviceRequestSchema);
