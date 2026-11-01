const mongoose = require('mongoose');

const postSchema = new mongoose.Schema({
  title: { type: String, required: true },
  price: { type: Number, required: true },
  province: { type: String, required: true },
  districtOrCity: { type: String, required: true },
  category: { type: String, required: true },
  description: { type: String, required: true },
  images: [{ type: String }],
  whatsapp: { type: String },
  phone: { type: String },
}, { timestamps: true });

module.exports = mongoose.model('Post', postSchema);
