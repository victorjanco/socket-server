const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const path = require('path');

const app = express();
const server = http.createServer(app);
// For multiple specific origins
const io = socketIo(server, {
  cors: {
    // origin: ["http://stocky.test", "http://localhost:8080", "http://192.168.1.*"],
    origin: "*", // Allow all origins 
    methods: ["GET", "POST"]
  }
});

// Or for all origins (not recommended for production)
// const io = socketIo(server, {
//   cors: {
//     origin: "*",
//     methods: ["GET", "POST"]
//   }
// });

// Serve static files
app.use(express.static(path.join(__dirname, 'public')));

// Store connected users
const users = {};

// Handle socket.io connections
io.on('connection', (socket) => {
  console.log(`New client connected: ${socket.id}`);

  // Event when user sets their username
  socket.on('set-username', (username) => {
    users[socket.id] = username;
    io.emit('user-connected', username);
    io.emit('update-users', Object.values(users));
    console.log(`User registered: ${username}`);
  });

  // Event for chat messages
  socket.on('send-message', (message) => {
    const username = users[socket.id] || 'Anonymous';
    io.emit('receive-message', { username, message });
    console.log(`Message from ${username}: ${message}`);
  });

  // Event for private messages
  socket.on('private-message', ({ recipientId, message }) => {
    const sender = users[socket.id] || 'Anonymous';
    io.to(recipientId).emit('private-message', {
      sender: sender,
      senderId: socket.id,
      message: message
    });
    console.log(`Private message from ${sender} to ${users[recipientId]}`);
  });

  // Disconnect event
  socket.on('disconnect', () => {
    const username = users[socket.id];
    if (username) {
      delete users[socket.id];
      io.emit('user-disconnected', username);
      io.emit('update-users', Object.values(users));
      console.log(`User disconnected: ${username}`);
    }
  });
});

// Main route
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Start server
const PORT = process.env.PORT || 3000;
const HOST = '0.0.0.0'; // Listen on all network interfaces
server.listen(PORT, HOST, () => {
    console.log(`Server listening at http://localhost:${PORT}`);
    console.log(`Accessible via public IP at http://<your-public-ip>:${PORT}`);
});