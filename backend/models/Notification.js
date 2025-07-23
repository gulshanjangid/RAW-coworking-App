const mongoose = require('mongoose');

const notificationSchema = new mongoose.Schema({
    username: { type: String, required: true },
    message: { type: String, required: true },
    channel: { type: String, required: true }, // WhatsApp, Email, etc.
    createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Notification', notificationSchema);
