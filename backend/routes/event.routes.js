const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');
const eventController = require('../controllers/event.controller');
  
// Multer configuration
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'uploads/');
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + path.extname(file.originalname));
    },
});
const upload = multer({ storage: storage });

// Routes
router.post('/add-event', upload.single('image'), eventController.addEvent);
router.get('/events', eventController.getAllEvents);
router.delete('/delete-event/:id', eventController.deleteEvent);
router.put('/update-event/:id', upload.single('image'), eventController.updateEvent);

module.exports = router;
