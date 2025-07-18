const mongoose = require('mongoose');

const meetingScheduleSchema = new mongoose.Schema({
 username: {                    // Automatically fetched from logged-in user
    type: String,
    required: true,
  },
  adminId: { type: String, default: null },         // Set when admin approves
  datetime: { type: Date, required: true },
  status: { type: String, enum: ['pending', 'approved', 'cancelled'], default: 'pending' },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('meeting_schedule', meetingScheduleSchema);
