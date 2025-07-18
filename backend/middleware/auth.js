const jwt = require('jsonwebtoken');

const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1]; // Format: "Bearer <token>"

    if (!token) {
        return res.status(401).json({ message: 'No token provided.' });
    }

    jwt.verify(token, 'gulshan@9352', (err, user) => {
        if (err) return res.status(403).json({ message: 'Invalid token.' });
        req.user = user; // Add user info to request
        next();
    });
};

module.exports = authenticateToken;
