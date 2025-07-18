const express = require('express');
const router = express.Router();
const { createMeeting, getAllMeetings, deleteMeeting, updateMeeting } = require('../controllers/meeting.controller');

const authenticateToken = require('../middleware/auth');
// POST - Book a meeting room
router.post('/book-meeting',authenticateToken, createMeeting);

// GET - Get all meetings
router.get('/meetings', getAllMeetings);
router.delete('/delete-meeting/:id', deleteMeeting);     // 🔥 DELETE
router.put('/update-meeting/:id', updateMeeting);        // ✏️ UPDATE
module.exports = router;
