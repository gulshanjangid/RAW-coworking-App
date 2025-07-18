const express = require('express');
const router = express.Router();
const { addUser, getAllUsers,loginUser, deleteUser,updateUser } = require('../controllers/user.controller');
const authenticateToken = require('../middleware/auth');
const isAdmin = require('../middleware/isAdmin');
// POST - Add New User
router.post('/add-user', addUser);

// GET - Fetch All Users
router.get('/users', getAllUsers);
// POST - User Login
router.post('/login', loginUser);

// DELETE - Delete User
router.delete('/delete-user/:id', deleteUser);

// PUT - Update User
router.put('/update-user/:id', updateUser);

module.exports = router;
