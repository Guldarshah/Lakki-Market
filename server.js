const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const Post = require('./models/Post'); // پوسٹ کا ماڈل

const app = express();
app.use(express.json());
app.use(cors());

// ہوم پیج روٹ تاکہ Cannot GET / کا ایرر نہ آئے
app.get('/', (req, res) => {
  res.send('Lakki Market Backend is Running Successfully!');
});

// 1. تمام پوسٹس کو سرور سے حاصل کرنے کا API (GET)
app.get('/api/posts', async (req, res) => {
  try {
    const posts = await Post.find().sort({ createdAt: -1 });
    res.json(posts);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 2. نئی پوسٹ ڈیٹا بیس میں محفوظ کرنے کا API (POST)
app.post('/api/posts', async (req, res) => {
  try {
    const newPost = new Post(req.body);
    const savedPost = await newPost.save();
    res.status(201).json(savedPost);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = app;
