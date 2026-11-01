const express = require('express');
const mongoose = require('mongoose');
const app = express();
app.use(express.json());

// Post Model import
const Post = require('./models/Post');

// 1. تمام فعال پوسٹس حاصل کریں (صوبہ، ضلع اور کیٹیگری فلٹر کے ساتھ)
app.get('/api/posts', async (req, res) => {
  try {
    const { province, districtOrCity, category } = req.query;
    let query = { isSold: false }; // صرف ایکٹیو پوسٹس نظر آئیں گی

    if (province) query.province = province;
    if (districtOrCity) query.districtOrCity = districtOrCity;
    if (category) query.category = category;

    let posts = await Post.find(query).sort({ createdAt: -1 });
    
    // اگر صارف نے لکی مروت منتخب کیا ہو تو اسے ترجیح دینے کا نظام
    if (districtOrCity === 'لکی مروت') {
      posts.sort((a, b) => (b.districtOrCity === 'لکی مروت' ? 1 : -1));
    }

    res.json(posts);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 2. نئی پوسٹ شامل کرنے کی API (ایڈمن کے لیے)
app.post('/api/posts', async (req, res) => {
  try {
    const newPost = new Post(req.body);
    await newPost.save();
    res.status(201).json({ message: 'Post created successfully', newPost });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// 3. پوسٹ کو Sold یا Active کرنے کی API
app.patch('/api/posts/:id/sold', async (req, res) => {
  try {
    const post = await Post.findById(req.params.id);
    if (!post) return res.status(404).json({ error: 'Post not found' });
    
    post.isSold = !post.isSold; // اگر ایکٹیو ہے تو سولڈ ہو جائے گی، اور وائس ورسا
    await post.save();
    res.json({ message: 'Post status updated successfully', post });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Lakki Market Server is running on port ${PORT}`);
});
