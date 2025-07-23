const connectedUsers = {};  // { username: socket.id }

function setupSocket(io) {
    io.on('connection', (socket) => {
        console.log('New client connected:', socket.id);

        socket.on('register', (username) => {
            connectedUsers[username] = socket.id;
            console.log(`User ${username} registered with socket ${socket.id}`);
        });

        socket.on('disconnect', () => {
            for (const [username, id] of Object.entries(connectedUsers)) {
                if (id === socket.id) {
                    delete connectedUsers[username];
                    console.log(`User ${username} disconnected.`);
                    break;
                }
            }
        });
    });
}

function sendNotificationToUser(io, username, message) {
    const socketId = connectedUsers[username];
    if (socketId) {
        io.to(socketId).emit('notification', message);
    }
}

module.exports = { setupSocket, sendNotificationToUser };
