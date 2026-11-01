import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'add_post_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedProvince = 'تمام صوبے';
  String selectedDistrict = 'لکی مروت';
  String selectedCategory = 'تمام کیٹیگریز';
  TextEditingController searchController = TextEditingController();

  List<dynamic> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  // بیک اینڈ سے ڈیٹا لانے کا فنکشن
  Future<void> fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse('https://your-backend-url.com/api/posts'),
      );

      if (response.statusCode == 200) {
        setState(() {
          posts = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('پوسٹس لوڈ کرنے میں ناکامی');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // فون کال کرنے کا فنکشن
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  // واٹس ایپ کھولنے کا فنکشن
  Future<void> _openWhatsApp(String phoneNumber) async {
    final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: SizedBox(
          height: 40,
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'لکی مارکیٹ میں تلاش کریں...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red),
                const SizedBox(width: 5),
                Text(
                  'آپ کا علاقہ: $selectedDistrict',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : posts.isEmpty
                    ? const Center(child: Text('کوئی پوسٹ دستیاب نہیں ہے'))
                    : ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return _buildFacebookPostCard(post);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPostScreen()),
          );
          fetchPosts();
        },
      ),
    );
  }

  Widget _buildFacebookPostCard(Map<String, dynamic> post) {
    List images = post['images'] ?? [];
    return Card(
      margin: const EdgeInsets.only(top: 8),
      elevation: 1,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.store, color: Colors.white),
            ),
            title: Text(post['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('📍 ${post['districtOrCity'] ?? ''}, ${post['province'] ?? ''}'),
            trailing: Text(
              'Rs ${post['price'] ?? 0}',
              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          if (images.isNotEmpty)
            Image.network(images[0], height: 300, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(post['description'] ?? '', style: const TextStyle(fontSize: 14)),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    onPressed: () {
                      String phone = post['whatsapp'] ?? post['phone'] ?? '';
                      if (phone.isNotEmpty) _openWhatsApp(phone);
                    },
                    icon: const Icon(Icons.message),
                    label: const Text('واٹس ایپ'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                    onPressed: () {
                      String phone = post['phone'] ?? '';
                      if (phone.isNotEmpty) _makePhoneCall(phone);
                    },
                    icon: const Icon(Icons.call),
                    label: const Text('کال کریں'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
