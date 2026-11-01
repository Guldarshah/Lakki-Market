const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const Post = require('./models/Post'); // پوسٹ کا ماڈل

const app = express();
app.use(express.json());
app.use(cors());

// 1. تمام پوسٹس کو سرور سے حاصل کرنے کا API (GET)
app.get('/api/posts', async (req, res) => {
  try {
    const posts = await Post.find().sort({ createdAt: -1 }); // نئی پوسٹ سب سے اوپر آئے گی
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
    res.status(400).json({ error: err.message });
  }
});

// سرور کا پورٹ
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
