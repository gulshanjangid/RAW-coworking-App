const ServiceRequest = require('../models/serviceRequest.model');
const User = require('../models/user.model');

// Create Service Request with User's Location
exports.createServiceRequest = async (req, res) => {
  try {
    const { title, description } = req.body;

    if (!title || !description) {
      return res.status(400).json({ message: 'Title and description are required.' });
    }

    // Get username from decoded JWT
    const username = req.user.username;

    // Fetch user from MongoDB
    const user = await User.findOne({ username });

    if (!user) {
      return res.status(404).json({ message: 'User not found.' });
    }

    const newRequest = new ServiceRequest({
      username: user.username,
      title,
      description,
      officeLocation: user.officeLocation,
      seatNumber: user.seatNumber
    });

    await newRequest.save();

    res.status(201).json({ message: 'Request created successfully.', request: newRequest });

  } catch (error) {
    console.error('Error creating service request:', error);
    res.status(500).json({ message: 'Server error' });
  }
};
// GET /api/requests/all
exports.getAllServiceRequests = async (req, res) => {
  try {
    const allRequests = await ServiceRequest.find().sort({ createdAt: -1 });
    res.status(200).json(allRequests);
  } catch (error) {
    console.error('Error fetching all service requests:', error);
    res.status(500).json({ message: 'Server error' });
  }
};
// Example controller method (to place in serviceRequest.controller.js)
exports.updateServiceRequestStatus = async (req, res) => {
  const { id } = req.params;
  const { status } = req.body;

  try {
    const updated = await ServiceRequest.findByIdAndUpdate(
      id,
      { status },
      { new: true }
    );

    if (!updated) {
      return res.status(404).json({ message: 'Request not found' });
    }

    res.json({ message: 'Status updated successfully', request: updated });
  } catch (err) {
    console.error('Error updating status:', err);
    res.status(500).json({ message: 'Server error' });
  }
};



// GET /api/requests/my
exports.getMyServiceRequests = async (req, res) => {
  try {
    const username = req.user.username; // Decoded from JWT
    const myRequests = await ServiceRequest.find({ username }).sort({ createdAt: -1 });
    res.status(200).json(myRequests);
  } catch (error) {
    console.error('Error fetching user requests:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

