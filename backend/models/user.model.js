const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    username: { type: String, required: true , unique: true, trim: true },
    password: { type: String, required: true },
    email: { type: String, required: true },
    officeLocation: { type: String, required: true },
    seatNumber: { type: String, required: true }
}, { timestamps: true });

const User = mongoose.model('User', userSchema);

module.exports = User;