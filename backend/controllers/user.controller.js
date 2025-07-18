const User = require('../models/user.model');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
// Create New User
const addUser = async (req, res) => {
    try {
        const { username, password, email, officeLocation, seatNumber } = req.body;
// Print all incoming fields to terminal
console.log('userName:', username);
console.log('password:', password);
console.log('email:', email);
console.log('officeLocation:', officeLocation);
console.log('seatNumber:', seatNumber);

        // Basic validation
    if (
    !username?.trim() || 
    !password?.trim() || 
    !email?.trim() ||
    !officeLocation?.trim() || 
    !seatNumber?.trim()
) {
    return res.status(400).json({ message: 'All fields are required and cannot be empty.' });
}

        // Check if user already exists
      const existingUser = await User.findOne({ username: username.trim() });
        if (existingUser) {
            return res.status(409).json({ message: 'User already exists.' });
        }
         const hashedPassword = await bcrypt.hash(password.trim(), 10);
        // Create and save new user
        const newUser = new User({ username, password: hashedPassword, email, officeLocation, seatNumber });
        await newUser.save();

        res.status(201).json({ message: 'User created successfully.', user: newUser });
    } catch (error) {
        res.status(500).json({ message: 'Server error.', error: error.message });
    }
};

// Get All Users
const getAllUsers = async (req, res) => {
    try {
      const users = await User.find({}, '-password'); 
         

     
        res.status(200).json(users);
    } catch (error) {
        res.status(500).json({ message: 'Server error.', error: error.message });
    }
};
// Login User
const loginUser = async (req, res) => {
    try {
        const { username, password } = req.body;

        if (!username?.trim() || !password?.trim()) {
            return res.status(400).json({ message: 'Username and password are required.' });
        }


        // ✅ Hardcoded Admin Check
        if (username.trim() === 'admin' && password.trim() === 'admin123') {
            // Create Admin Token
            const token = jwt.sign(
                { username: 'admin', role: 'admin' },
                'gulshan@9352',
                { expiresIn: '1h' }
            );

            return res.status(200).json({
                success: true,
                message: 'Admin login successful.',
                token,
                user: {
                    username: 'admin',
                    role: 'admin'
                }
            });
        }

  
        const user = await User.findOne({ username: username.trim() });

        if (!user) {
            return res.status(401).json({ success: false, message: 'Invalid username or password.' });
        }
        // Check password
const isPasswordValid = await bcrypt.compare(password.trim(), user.password);
if (!isPasswordValid) {
    return res.status(401).json({ success: false, message: 'Invalid username or password.' });
}


// Create JWT Token
const token = jwt.sign(
    {
        id: user._id,
        username: user.username,
        seatNumber: user.seatNumber,
        officeLocation: user.officeLocation
    },
    'gulshan@9352', // Replace with your real secret key, store in .env
    { expiresIn: '1h' }
);

// ✅ Print to VS Code Terminal
        console.log('--------------------------------');
        console.log('✅ User Logged In Successfully:');
        console.log('Username:', user.username);
        console.log('Seat Number:', user.seatNumber);
        console.log('Office Location:', user.officeLocation);
        console.log('Token:', token);
        console.log('--------------------------------');
       
// Return token and user info
res.status(200).json({
    success: true,
    message: 'Login successful.',
    token,
    user: {
        username: user.username,
        seatNumber: user.seatNumber,
        officeLocation: user.officeLocation
    }
});
    } catch (error) {
        res.status(500).json({ success: false, message: 'Server error.', error: error.message });
    }
};
// Delete User
const deleteUser = async (req, res) => {
    try {
        const { id } = req.params;

        const deletedUser = await User.findByIdAndDelete(id);

        if (!deletedUser) {
            return res.status(404).json({ message: 'User not found.' });
        }

        res.status(200).json({ message: 'User deleted successfully.', user: deletedUser });
    } catch (error) {
        res.status(500).json({ message: 'Server error.', error: error.message });
    }
};

const updateUser = async (req, res) => {
    try {
        const { id } = req.params;
        const { userName, password, officeLocation, seatNumber } = req.body;

        if (
            !userName?.trim() ||
            !password?.trim() ||
            !officeLocation?.trim() ||
            !seatNumber?.trim()
        ) {
            return res.status(400).json({ message: 'All fields are required and cannot be empty.' });
        }

        // Hash new password
        const hashedPassword = await bcrypt.hash(password.trim(), 10);

        const updatedUser = await User.findByIdAndUpdate(
            id,
            { username: userName.trim(), password: hashedPassword, officeLocation: officeLocation.trim(), seatNumber: seatNumber.trim() },
            { new: true }
        );

        if (!updatedUser) {
            return res.status(404).json({ message: 'User not found.' });
        }

        res.status(200).json({ message: 'User updated successfully.', user: updatedUser });
    } catch (error) {
        res.status(500).json({ message: 'Server error.', error: error.message });
    }
};



module.exports = { addUser, getAllUsers, loginUser, deleteUser, updateUser };

