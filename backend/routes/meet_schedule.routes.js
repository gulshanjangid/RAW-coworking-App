const express = require('express');
const router = express.Router();
const meetingController = require('../controllers/meet_schedule.controller');

const authenticateToken = require('../middleware/auth');
 
// USER SIDE
router.post('/request', authenticateToken, meetingController.createMeetingRequest);
router.get('/user', authenticateToken, meetingController.getUserMeetings);
// ADMIN SIDE
router.get('/pending', meetingController.getPendingMeetings);
router.post('/approve', meetingController.approveMeeting);
router.get('/admin/:adminId', meetingController.getAdminMeetings);

// Optional: Cancel Meeting (User/Admin)
router.post('/cancel', meetingController.cancelMeeting);

module.exports = router;
