```dart
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
        Uri.parse('https://lakki-market-rlv8.vercel.app/api/posts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': titleController.text,
          'price': priceController.text,
          'description': descriptionController.text,
          'imageUrl': imageController.text,
          'phone': phoneController.text,
          'whatsapp': whatsappController.text,
          'province': selectedProvince,
          'district': selectedDistrict,
          'category': selectedCategory,
        }),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('پوسٹ کامیابی سے شائع ہو گئی!')),
        );
        Navigator.pop(context);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خرابی: ${response.body}')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('سرور سے رابطہ نہ ہو سکا: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نئی پوسٹ شامل کریں'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'عنوان (Title)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'عنوان درج کریں' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'قیمت (Price)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'قیمت درج کریں' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'کیٹیگری',
                  border: OutlineInputBorder(),
                ),
                items: categories.map((String cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => selectedCategory = val);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedProvince,
                decoration: const InputDecoration(
                  labelText: 'صوبہ',
                  border: OutlineInputBorder(),
                ),
                items: provinces.map((String prov) {
                  return DropdownMenuItem(value: prov, child: Text(prov));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => selectedProvince = val);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'تفصیل (Description)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'تفصیل درج کریں' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: imageController,
                decoration: const InputDecoration(
                  labelText: 'تصویر کا یو آر ایل (Image URL)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'فون نمبر',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'نمبر درج کریں' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: whatsappController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'واٹس ایپ نمبر',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : submitPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'شائع کریں',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```
