const express = require('express');
const router = express.Router();
const serviceRequestController = require('../controllers/serviceRequest.controller');
 const authenticateToken = require('../middleware/auth'); 
// Create service request
router.post('/create',  authenticateToken, serviceRequestController.createServiceRequest);
 
// Get all service requests (Admin)
router.get('/all',serviceRequestController.getAllServiceRequests); // admin

 // ✅ Update status of a service request (Admin)
router.put('/:id/status', serviceRequestController.updateServiceRequestStatus);
// Get my service requests (User)
router.get('/my', authenticateToken, serviceRequestController.getMyServiceRequests); // user
module.exports = router;
  