const Event = require('../models/Event');

// ✅ Add New Event
exports.addEvent = async (req, res) => {
    const { title, description, date, category } = req.body;

    if (!title || !description || !date || !category) {
        return res.status(400).json({ message: 'All fields are required' });
    }

    try {
        const newEvent = new Event({
            title,
            description,
            date,
            category,
            imageUrl: req.file ? `${req.protocol}://${req.get('host')}/uploads/${req.file.filename}` : null,
        });

        await newEvent.save();
        res.status(201).json({ message: 'Event published successfully', event: newEvent });
    } catch (error) {
        res.status(500).json({ message: 'Server error', error: error.message });
    }
};

// ✅ Get All Events
exports.getAllEvents = async (req, res) => {
    try {
        const events = await Event.find();
        res.json(events);
    } catch (error) {
        res.status(500).json({ message: 'Server error', error: error.message });
    }
};

// ✅ Delete Event
exports.deleteEvent = async (req, res) => {
    try {
        await Event.findByIdAndDelete(req.params.id);
        res.json({ message: 'Event deleted successfully' });
    } catch (error) {
        res.status(500).json({ message: 'Server error', error: error.message });
    }
};

// ✅ Update Event
exports.updateEvent = async (req, res) => {
    try {
        const updateData = req.body;

        if (req.file) {
            updateData.imageUrl = `${req.protocol}://${req.get('host')}/uploads/${req.file.filename}`;
        }

        const updatedEvent = await Event.findByIdAndUpdate(req.params.id, updateData, { new: true });

        if (!updatedEvent) {
            return res.status(404).json({ message: 'Event not found' });
        }

        res.json({ message: 'Event updated successfully', event: updatedEvent });
    } catch (error) {
        res.status(500).json({ message: 'Server error', error: error.message });
    }
};
