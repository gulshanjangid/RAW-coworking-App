const express = require('express');
const app = express();
const port = 8080 || process.env.PORT;
const cors = require('cors');
const bodyParser = require('body-parser');
const userRoutes = require('./routes/user.routes');
const mongoose = require('mongoose');
const meetingRoutes = require('./routes/meeting.routes');
const eventRoutes = require('./routes/event.routes');
const serviceRequestRoutes = require('./routes/serviceRequest.routes');
const meet_scheduleRoutes = require('./routes/meet_schedule.routes');
const notificationRoutes = require('./routes/notification.routes');
const socketIo = require('socket.io');
const { setupSocket } = require('./sockets/socketManager');
app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use('/uploads', express.static('uploads')); // Serve uploaded images


// Initialize Socket.IO
const server = require('http').createServer(app);
const io = socketIo(server, {
    cors: {
        origin: '*', // Allow all origins for simplicity, adjust as needed
        methods: ['GET', 'POST']
    }
});


setupSocket(io);
app.set('socketio', io);

mongoose.connect('mongodb://localhost:27017/coworkingdb', { useNewUrlParser: true, useUnifiedTopology: true })
    .then(() => {
        console.log('MongoDB connected.');
   
       
        app.use('/', userRoutes);
        app.use('/meetings', meetingRoutes);
        app.use('/api/events', eventRoutes);
        app.use('/api/requests', serviceRequestRoutes);
        app.use('/api/meet_schedule', meet_scheduleRoutes);
        app.use('/api/notifications', require('./routes/notification.routes'));
       
// Pass io to requests
app.use((req, res, next) => {
    req.io = app.get('socketio');
    next();
});

// Routes
app.use('/api/notifications', notificationRoutes);
        app.listen(port, () => {
            console.log('Server running on port ' + port);
        }); 
    })
    .catch(err => {
        console.error('MongoDB connection error:', err.message);
    });
