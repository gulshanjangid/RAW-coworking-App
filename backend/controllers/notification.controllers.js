const Notification = require('../models/Notification');
const { sendNotificationToUser } = require('../sockets/socketManager');

async function sendReminder(req, res) {
    const { username, message, channel } = req.body;

    if (!username || !message || !channel) {
        return res.status(400).json({ error: 'Missing required fields.' });
    }

    try {
        // Save notification to MongoDB
        await Notification.create({ username, message, channel });

        // Send notification in real-time if user connected
        sendNotificationToUser(req.io, username, { message, channel });

        res.json({ success: true, message: 'Notification sent.' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to send notification.' });
    }
}

async function getUserNotifications(req, res) {
    const { username } = req.params;

    try {
        const notifications = await Notification.find({ username }).sort({ createdAt: -1 });
        res.json(notifications);
    } catch (error) {
        res.status(500).json({ error: 'Failed to fetch notifications.' });
    }
}

module.exports = { sendReminder, getUserNotifications };
