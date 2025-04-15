const socket = io();

// Basic chat functionality
const messageInput = document.getElementById('messageInput');
const messagesDiv = document.getElementById('messages');

messageInput.addEventListener('keypress', (e) => {
    if (e.key === 'Enter' && messageInput.value.trim()) {
        socket.emit('send-message', messageInput.value);
        messageInput.value = '';
    }
});

socket.on('receive-message', (data) => {
    const messageElement = document.createElement('div');
    messageElement.textContent = `${data.username}: ${data.message}`;
    messagesDiv.appendChild(messageElement);
});