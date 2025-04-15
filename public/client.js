document.addEventListener('DOMContentLoaded', () => {
  const socket = io();
  let currentUser = '';
  
  // DOM elements
  const loginSection = document.getElementById('loginSection');
  const chatSection = document.getElementById('chatSection');
  const usernameInput = document.getElementById('usernameInput');
  const loginButton = document.getElementById('loginButton');
  const messageInput = document.getElementById('messageInput');
  const sendButton = document.getElementById('sendButton');
  const messagesContainer = document.getElementById('messagesContainer');
  const usersList = document.getElementById('usersList');
  const privateMessageModal = document.getElementById('privateMessageModal');
  const privateMessageContent = document.getElementById('privateMessageContent');
  const closePrivateMessageModal = document.getElementById('closePrivateMessageModal');

  // Join chat
  loginButton.addEventListener('click', () => {
    const username = usernameInput.value.trim();
    if (username) {
      currentUser = username;
      socket.emit('set-username', username);
      loginSection.style.display = 'none';
      chatSection.style.display = 'flex';
      messageInput.focus();
    }
  });

  // Send message
  sendButton.addEventListener('click', sendMessage);
  messageInput.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') sendMessage();
  });

  function sendMessage() {
    const message = messageInput.value.trim();
    if (message) {
      socket.emit('send-message', message);
      addMessage(currentUser, message, true);
      messageInput.value = '';
    }
  }

  // Receive messages
  socket.on('receive-message', ({ username, message }) => {
    addMessage(username, message, false);
  });

  // Update users list
  socket.on('update-users', (users) => {
    usersList.innerHTML = '';
    users.forEach(user => {
      const li = document.createElement('li');
      li.textContent = user;
      
      // Add private message button
      const pmButton = document.createElement('button');
      pmButton.textContent = 'PM';
      pmButton.className = 'pm-button';
      pmButton.addEventListener('click', () => openPrivateMessageModal(user));
      
      li.appendChild(pmButton);
      usersList.appendChild(li);
    });
  });

  // Handle private messages
  socket.on('private-message', ({ sender, message }) => {
    privateMessageContent.innerHTML += `<p><strong>${sender}:</strong> ${message}</p>`;
    privateMessageModal.style.display = 'block';
  });

  // Open private message modal
  function openPrivateMessageModal(recipient) {
    const pmInput = document.createElement('input');
    pmInput.type = 'text';
    pmInput.placeholder = `Message to ${recipient}`;
    
    const pmSendButton = document.createElement('button');
    pmSendButton.textContent = 'Send';
    
    pmSendButton.addEventListener('click', () => {
      const message = pmInput.value.trim();
      if (message) {
        socket.emit('private-message', { recipientId: socket.id, message });
        pmInput.value = '';
      }
    });
    
    privateMessageContent.innerHTML = '';
    privateMessageContent.appendChild(pmInput);
    privateMessageContent.appendChild(pmSendButton);
    privateMessageModal.style.display = 'block';
  }

  // Close private message modal
  closePrivateMessageModal.addEventListener('click', () => {
    privateMessageModal.style.display = 'none';
  });

  // Connection/disconnection notifications
  socket.on('user-connected', (username) => {
    addSystemMessage(`${username} joined the chat`);
  });

  socket.on('user-disconnected', (username) => {
    addSystemMessage(`${username} left the chat`);
  });

  // Helper functions
  function addMessage(username, message, isOwn) {
    const messageDiv = document.createElement('div');
    messageDiv.className = `message ${isOwn ? 'own-message' : 'other-message'}`;
    
    const userSpan = document.createElement('span');
    userSpan.className = 'message-user';
    userSpan.textContent = username;
    
    const textSpan = document.createElement('span');
    textSpan.className = 'message-text';
    textSpan.textContent = message;
    
    messageDiv.appendChild(userSpan);
    messageDiv.appendChild(textSpan);
    messagesContainer.appendChild(messageDiv);
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
  }

  function addSystemMessage(text) {
    const systemDiv = document.createElement('div');
    systemDiv.className = 'system-message';
    systemDiv.textContent = text;
    messagesContainer.appendChild(systemDiv);
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
  }
});