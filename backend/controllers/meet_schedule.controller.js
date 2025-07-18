const Meeting = require('../models/meet_schedule.model');
 


// Create Meeting Request (User)
exports.createMeetingRequest = async (req, res) => {
  const { datetime } = req.body;

  try {
    const username = req.user.username;  // Extracted from token/session automatically

    const meeting = new Meeting({
      username,
      datetime,
    });
    await meeting.save();
    res.status(201).json({ message: 'Meeting request submitted.', meeting });
  } catch (error) {
    res.status(500).json({ message: 'Error creating meeting request.', error });
  }
};

// Get All Pending Meetings (Admin)
exports.getPendingMeetings = async (req, res) => {
  try {
    const meetings = await Meeting.find({ status: 'pending' }).sort({ createdAt: -1 });
    res.status(200).json(meetings);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching pending meetings.', error });
  }
};

// Approve Meeting (Admin)
exports.approveMeeting = async (req, res) => {
  const { meetingId, adminId, meetingLink } = req.body;

  try {
    const meeting = await Meeting.findByIdAndUpdate(
      meetingId,
      { status: 'approved', adminId, meetingLink },
      { new: true }
    );

    if (!meeting) {
      return res.status(404).json({ message: 'Meeting not found.' });
    }

    res.status(200).json({ message: 'Meeting approved.', meeting });
  } catch (error) {
    res.status(500).json({ message: 'Error approving meeting.', error });
  }
};

// Get All Meetings for a User
exports.getUserMeetings = async (req, res) => {
  try {
    const username = req.user.username;  // Comes from middleware

    const meetings = await Meeting.find({ username }).sort({ createdAt: -1 });

    res.status(200).json(meetings);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching meetings', error });
  }
};

// Get All Meetings for Admin
exports.getAdminMeetings = async (req, res) => {
  const { adminId } = req.params;

  try {
    const meetings = await Meeting.find({ adminId }).sort({ createdAt: -1 });
    res.status(200).json(meetings);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching admin meetings.', error });
  }
};

// Optional: Cancel Meeting (User or Admin)
exports.cancelMeeting = async (req, res) => {
  const { meetingId } = req.body;

  try {
    const meeting = await Meeting.findByIdAndUpdate(
      meetingId,
      { status: 'cancelled' },
      { new: true }
    );

    if (!meeting) {
      return res.status(404).json({ message: 'Meeting not found.' });
    }

    res.status(200).json({ message: 'Meeting cancelled.', meeting });
  } catch (error) {
    res.status(500).json({ message: 'Error cancelling meeting.', error });
  }
};

