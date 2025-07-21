const mongoose = require('mongoose');

const MeetingSchema = new mongoose.Schema({
    username: { type: String, required: true },
    location: { type: String, required: true },
    date: { type: String, required: true },
    timeSlot: { type: String, required: true },
    name: { type: String, required: true },
    phone: { type: String, required: true },
    price: { type: Number, required: true },
});

module.exports = mongoose.model('Meeting', MeetingSchema);

