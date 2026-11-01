import 'package:flutter/material.dart';
import 'add_post_screen.dart'; // یہ نئی پوسٹ والی سکرین کے ساتھ جوڑتا ہے

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

  final List<String> provinces = [
    'تمام صوبے',
    'خیبر پختونخوا (KPK)',
    'پنجاب',
    'سندھ',
    'بلوچستان',
    'اسلام آباد',
    'گلگت بلتستان',
    'آزاد کشمیر'
  ];

  final List<String> categories = [
    'تمام کیٹیگریز',
    'موبائل و الیکٹرانکس',
    'گاڑیاں و موٹر سائیکل',
    'پراپرٹی و زمین',
    'مویشی و جانور',
    'گھریلو سامان',
    'ملازمتیں و خدمات'
  ];

  final List> dummyPosts = [
    {
      'title': 'سیمسنگ گلیکسی S23 الٹرا',
      'price': '185,000',
      'province': 'خیبر پختونخوا (KPK)',
      'districtOrCity': 'لکی مروت',
      'description': 'بالکل صاف موبائل ہے، 12 جی بی ریم اور 256 جی بی میموری، ڈبہ اور چارجر ساتھ ہے۔',
      'images': [
        'https://via.placeholder.com/600x400',
      ],
      'whatsapp': '03001234567',
      'phone': '03001234567',
    }
  ];

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
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {},
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'settings', child: Text('سیٹنگز')),
              const PopupMenuItem(value: 'about', child: Text('ایپ کے بارے میں')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),
                    const SizedBox(width: 5),
                    Text(
                      'آپ کا علاقہ: $selectedDistrict',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: const Text('فلٹر تبدیل کریں'),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: 35,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      bool isSelected = selectedCategory == categories[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(categories[index]),
                          selected: isSelected,
                          selectedColor: Colors.blue,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          onSelected: (selected) {
                            setState(() {
                              selectedCategory = categories[index];
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dummyPosts.length,
              itemBuilder: (context, index) {
                final post = dummyPosts[index];
                return _buildFacebookPostCard(post);
              },
            ),
          ),
        ],
      ),
      // نیا پلس بٹن جو پوسٹ ایڈ کرنے والی سکرین پر لے جائے گا
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPostScreen()),
          );
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
            title: Text(post['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('📍 ${post['districtOrCity']}, ${post['province']}'),
            trailing: Text(
              'Rs ${post['price']}',
              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          if (images.isNotEmpty)
            Image.network(images[0], height: 300, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(post['description'], style: const TextStyle(fontSize: 14)),
          ),
          const Divider(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.thumb_up_alt_outlined, color: Colors.grey),
                label: const Text('لائک', style: TextStyle(color: Colors.grey)),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chat_bubble_outline, color: Colors.grey),
                label: const Text('کمنٹ', style: TextStyle(color: Colors.grey)),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share_outlined, color: Colors.grey),
                label: const Text('شیئر', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    onPressed: () {},
                    icon: const Icon(Icons.message),
                    label: const Text('واٹس ایپ'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                    onPressed: () {},
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
