const mongoose = require('mongoose');

const postSchema = new mongoose.Schema({
  title: { type: String, required: true },
  description: { type: String, required: true },
  price: { type: Number, required: true },
  category: { type: String, required: true }, // تمام کیٹیگریز کے لیے (موبائل، موٹر سائیکل، پراپرٹی وغیرہ)
  province: { type: String, required: true }, // صوبہ (پنجاب، سندھ، کے پی کے، بلوچستان، گلگت، آزاد کشمیر، اسلام آباد)
  districtOrCity: { type: String, required: true }, // ضلع یا شہر (لکی مروت، بنوں، پشاور، لاہور، کراچی وغیرہ)
  images: [{ type: String }], // [0] = بڑی تصویر، [1,2,3] = تین چھوٹی تصاویر
  contactNumber: { type: String, required: true },
  whatsappNumber: { type: String, required: true },
  isSold: { type: Boolean, default: false }, // سولڈ آئٹمز ہینڈل کرنے کے لیے
  postedBy: { type: String, default: 'Admin' },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Post', postSchema);
