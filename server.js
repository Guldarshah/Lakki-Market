const express = require('express');
const mongoose = require('mongoose');
const app = express();
app.use(express.json());

// Lakki Market Backend API
app.get('/', (req, res) => {
  res.send('Lakki Market API is running successfully!');
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
