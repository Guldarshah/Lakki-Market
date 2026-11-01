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

  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();

  String selectedProvince = 'خیبر پختونخوا (KPK)';
  String selectedDistrict = 'لکی مروت';
  String selectedCategory = 'موبائل و الیکٹرانکس';

  bool isLoading = false;

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

  // پوسٹ کو سرور پر بھیجنے کا فنکشن
  Future<void> submitPost() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://your-backend-url.com/api/posts'), // اپنے بیک اینڈ کا لنک یہاں درج کریں
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': titleController.text,
          'price': double.parse(priceController.text),
          'province': selectedProvince,
          'districtOrCity': selectedDistrict,
          'category': selectedCategory,
          'description': descriptionController.text,
          'images': [imageController.text],
          'phone': phoneController.text,
          'whatsapp': whatsappController.text,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('پوسٹ کامیابی سے شائع ہو گئی!')),
        );
        Navigator.pop(context); // واپس ہوم اسکرین پر جائیں
      } else {
        throw Exception('پوسٹ محفوظ کرنے میں خرابی');
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
        title: const Text('نئی پوسٹ شامل کریں'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'اشتہار کا عنوان (Title)'),
                validator: (value) => value!.isEmpty ? 'عنوان درج کریں' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'قیمت (روپے میں)'),
                validator: (value) => value!.isEmpty ? 'قیمت درج کریں' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedProvince,
                items: provinces.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                onChanged: (val) => setState(() => selectedProvince = val!),
                decoration: const InputDecoration(labelText: 'صوبہ'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: TextEditingController(text: selectedDistrict),
                onChanged: (val) => selectedDistrict = val,
                decoration: const InputDecoration(labelText: 'ضلع / شہر (مثلاً لکی مروت)'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setState(() => selectedCategory = val!),
                decoration: const InputDecoration(labelText: 'کیٹیگری'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: imageController,
                decoration: const InputDecoration(labelText: 'تصویر کا لنک (Image URL)'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'فون نمبر (مثلاً 03001234567)'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: whatsappController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'واٹس ایپ نمبر'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'تفصیل (Description)'),
                validator: (value) => value!.isEmpty ? 'تفصیل درج کریں' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                  onPressed: isLoading ? null : submitPost,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('اشتہار شائع کریں', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
