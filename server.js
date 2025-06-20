const fs = require('fs');
const https = require('https');
const http = require('http');
const express = require('express');
const socketIo = require('socket.io');
const path = require('path');

const app = express();

// Environment configuration
const isProduction = process.env.NODE_ENV === 'production';

// Create server based on environment
let server;
if (isProduction) {
    const options = {
      key: fs.readFileSync('claveprivadakey.pem'),
      cert: fs.readFileSync('certificado.pem')
    };
    // server = https.createServer(app);
    server = https.createServer(options, app);
} else {
    server = http.createServer(app);
}

// Socket.io configuration
const io = socketIo(server, {
    cors: {
        origin: isProduction
            ? ["*"] // Production origins
            : ["http://stocky.test", "http://localhost:8080", "http://192.168.1.*"], // Development origins
        methods: ["GET", "POST"],
        allowedHeaders: ["Referer"]
    }
});

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

  // Event for chat messages
  socket.on('new-order', (message) => {
    const username = users[socket.id] || 'Anonymous';
    io.emit('receive-order', { username, message });
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
const HOST = '0.0.0.0';
server.listen(PORT, HOST, () => {
  const networkInterfaces = require('os').networkInterfaces();
  const ipv4 = Object.values(networkInterfaces)
      .flat()
      .find(i => i.family === 'IPv4' && !i.internal)?.address;

  console.log(`Server listening at ${isProduction ? 'https' : 'http'}://localhost:${PORT}`);
  if (!isProduction) {
      console.log(`Accessible via network at http://${ipv4}:${PORT}`);
  }
});