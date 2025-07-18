// controllers/meeting.controller.js

const Meeting = require('../models/meeting.model');
const User = require('../models/user.model');
const sendMail = require('../utils/mailer');

// 🆕 import templates
const userBookingTemplate = require('../utils/emails/userBookingTemplate');
const adminBookingTemplate = require('../utils/emails/adminBookingTemplate');
// Create a new meeting booking
const createMeeting = async (req, res) => {
    try {
        const { location, date, timeSlot, name, phone, price } = req.body;
        const username = req.user?.username; // username extracted from token by middleware

        if (!username || !location || !date || !timeSlot || !name || !phone || !price) {
            return res.status(400).json({ message: 'All fields are required.' });
        }

        const meeting = new Meeting({ username, location, date, timeSlot, name, phone, price });
        await meeting.save();
        const userHtml = userBookingTemplate({ username, name, phone, location, date, timeSlot, price });
        const adminHtml = adminBookingTemplate({ username, name, phone, location, date, timeSlot, price });

        const user = await User.findOne({ username });

if (!user || !user.email) {
    return res.status(400).json({ message: 'User not found or email missing.' });
}

        // Send email to user
        await sendMail(user.email, '✅ Booking Confirmed', userHtml);

        // Send email to admin
        await sendMail('anshulsharma1442@gmail.com', '📩 New Meeting Room Booking', adminHtml);
        
        res.status(201).json({ message: 'Meeting booked successfully.', meeting });
    } catch (error) {
        res.status(500).json({ message: 'Server error.', error: error.message });
    }
};

// Get all meetings
const getAllMeetings = async (req, res) => {
    try {
        const meetings = await Meeting.find();
        res.status(200).json(meetings);
    } catch (error) {
        res.status(500).json({ message: 'Server error.', error: error.message });
    }
};

// 🗑️ Delete a meeting
const deleteMeeting = async (req, res) => {
    try {
        const { id } = req.params;

        const deleted = await Meeting.findByIdAndDelete(id);

        if (!deleted) {
            return res.status(404).json({ message: 'Meeting not found.' });
        }

        res.status(200).json({ message: 'Meeting deleted successfully.' });
    } catch (error) {
        res.status(500).json({ message: 'Server error.', error: error.message });
    }
};

// ✏️ Update a meeting
const updateMeeting = async (req, res) => {
    try {
        const { id } = req.params;
        const updates = req.body;

        const updated = await Meeting.findByIdAndUpdate(id, updates, { new: true });

        if (!updated) {
            return res.status(404).json({ message: 'Meeting not found.' });
        }

        res.status(200).json({ message: 'Meeting updated successfully.', meeting: updated });
    } catch (error) {
        res.status(500).json({ message: 'Server error.', error: error.message });
    }
};


module.exports = { createMeeting, getAllMeetings , deleteMeeting, updateMeeting };
