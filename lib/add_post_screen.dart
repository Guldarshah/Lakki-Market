import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String selectedProvince = 'خیبر پختونخوا (KPK)';
  String selectedDistrict = 'لکی مروت';
  String selectedCategory = 'موبائل و الیکٹرانکس';

  final List<String> provinces = [
    'خیبر پختونخوا (KPK)',
    'پنجاب',
    'سندھ',
    'بلوچستان',
    'اسلام آباد',
    'گلگت بلتستان',
    'آزاد کشمیر'
  ];

  final List<String> categories = [
    'موبائل و الیکٹرانکس',
    'گاڑیاں و موٹر سائیکل',
    'پراپرٹی و زمین',
    'مویشی و جانور',
    'گھریلو سامان',
    'ملازمتیں و خدمات'
  ];

  bool isLoading = false;

  // پوسٹ کو سرور پر بھیجنے کا فنکشن
  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      // نوٹ: لوکل ہوسٹ کے لیے آپ اپنے سرور کا لنک یا IP استعمال کریں گے
      final response = await http.post(
        Uri.parse('https://your-backend-url.com/api/posts'), 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': _titleController.text,
          'price': double.parse(_priceController.text),
          'province': selectedProvince,
          'districtOrCity': selectedDistrict,
          'category': selectedCategory,
          'description': _descriptionController.text,
          'images': [_imageController.text], // فی الحال تصویر کا لنک
          'whatsapp': _phoneController.text,
          'phone': _phoneController.text,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('پوسٹ کامیابی کے ساتھ شائع ہو گئی ہے!')),
        );
        Navigator.pop(context);
      } else {
        throw Exception('پوسٹ اپ لوڈ کرنے میں ناکامی');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خرابی: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نئی پوسٹ یا اشتہار لگائیں'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'پروڈکٹ کا نام (عنوان)'),
                validator: (val) => val!.isEmpty ? 'براہ کرم نام درج کریں' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'قیمت (روپے میں)'),
                validator: (val) => val!.isEmpty ? 'براہ کرم قیمت درج کریں' : null,
              ),
              const SizedBox(height: 15),
              // صوبہ سلیکٹر
              DropdownButtonFormField<String>(
                value: selectedProvince,
                decoration: const InputDecoration(labelText: 'صوبہ'),
                items: provinces.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList,
                onChanged: (val) => setState(() => selectedProvince = val!),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: TextEditingController(text: selectedDistrict),
                decoration: const InputDecoration(labelText: 'ضلع یا شہر (مثلاً لکی مروت)'),
                onChanged: (val) => selectedDistrict = val,
              ),
              const SizedBox(height: 15),
              // کیٹیگری سلیکٹر
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(labelText: 'کیٹیگری'),
                items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList,
                onChanged: (val) => setState(() => selectedCategory = val!),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'تصویر کا لنک (Image URL)'),
                validator: (val) => val!.isEmpty ? 'تصویر کا لنک لازمی ہے' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'فون نمبر یا واٹس ایپ نمبر'),
                validator: (val) => val!.isEmpty ? 'نمبر درج کریں' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'تفصیل (Description)'),
                validator: (val) => val!.isEmpty ? 'تفصیل لکھیں' : null,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: isLoading ? null : _submitPost,
                child: isLoading
                    const CircularProgressIndicator(color: Colors.white)
                    : const Text('پوسٹ پبلش کریں', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
