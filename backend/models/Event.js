const mongoose = require('mongoose');

const EventSchema = new mongoose.Schema({
    title: { type: String, required: true },
    description: { type: String, required: true },
    date: { type: Date, required: true },
    category: { type: String, required: true },
    imageUrl: { type: String, required: false },
});

module.exports = mongoose.model('Event', EventSchema);
 