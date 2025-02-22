const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { initialize } = require('./server/database');
const routes = require('./server/routes');

const app = express();
const port = 3000;

// Debug middleware (Logs every request)
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
  next();
});

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(express.static('public'));

// Database Initialization
const db = initialize();
if (!db) {
  console.error('Failed to initialize database');
  process.exit(1); // Stop execution if DB fails
} else {
  console.log('Database initialized successfully');
}

// API Routes
app.use(routes);

// Error Handling Middleware
app.use((err, req, res, next) => {
  console.error('Server error:', err.message);
  res.status(500).json({ error: 'Internal Server Error' });
});

// Start the Server
app.listen(port, () => {
  console.log(`🚀 Server running at http://localhost:${port}`);
  console.log('🔍 Test endpoint: http://localhost:3000/api/login');
});