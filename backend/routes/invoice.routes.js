const express = require('express');
const router = express.Router();
const invoiceController = require('../controllers/invoice.controller');
const multer = require('multer');
const path = require('path');

// Multer setup
const storage = multer.diskStorage({
  destination: './uploads/',
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  }
});
const upload = multer({ storage });

// Admin
router.post('/create', invoiceController.createInvoice);
router.get('/all', invoiceController.getAllInvoices); // ✅ NEW
// User
router.get('/user/:id', invoiceController.getUserInvoices);
router.post('/pay/:invoiceId', upload.single('image'), invoiceController.uploadPaymentImage);
router.post('/reject/:invoiceId', invoiceController.rejectInvoice);

module.exports = router;
