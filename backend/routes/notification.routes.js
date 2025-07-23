const express = require('express');
const router = express.Router();
const { sendReminder, getUserNotifications } = require('../controllers/notification.controllers');

// Admin sends notification
router.post('/send', sendReminder);

// User fetches notifications (optional for history)
router.get('/user/:username', getUserNotifications);

module.exports = router;
