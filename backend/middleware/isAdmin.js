const jwt = require('jsonwebtoken');

const isAdmin = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) return res.status(401).json({ message: 'Token required' });

    jwt.verify(token, 'gulshan@9352', (err, user) => {
        if (err) return res.status(403).json({ message: 'Invalid token' });

        if (user.username !== 'admin') return res.status(403).json({ message: 'Access denied' });

        req.user = user;
        next();
    });
};

module.exports = isAdmin;
