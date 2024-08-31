import 'package:flutter/material.dart';

void main() {
  runApp(const VegetablesApp());
}

class VegetablesApp extends StatelessWidget {
  const VegetablesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return VegetablesScreen();
  }
}

class VegetablesScreen extends StatelessWidget {
  final List<Map<String, String>> vegetables = [
    {'name': 'Ampalaya (Bitter Melon)', 'image': 'images/Ampalaya.png'},
    {'name': 'Upo (Bottle Gourd)', 'image': 'images/Upo.jpg'},
    {'name': 'Sayote (Chayote)', 'image': 'images/Sayote.jpg'},
    {'name': 'Talong (Eggplant)', 'image': 'images/Talong.jpg'},
    {'name': 'Okra', 'image': 'images/Okra.jpg'},
  ];

  VegetablesScreen({super.key});

  void _onBottomNavItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home'); // Replace with actual HomePage
        break;
      case 1:
        // Handle navigation to Forums
        break;
      case 2:
        // Handle navigation to Updates
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vegetables'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border),
            onPressed: () {
              // Add bookmark functionality here
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Choose a Vegetable',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: vegetables.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.all(19.0),
                  leading: Image.asset(
                    vegetables[index]['image']!,
                    width: 80,
                    height: 100, // Increased height for the image
                    fit: BoxFit.cover,
                  ),
                  title: Text(vegetables[index]['name']!),
                  trailing: Icon(Icons.more_vert),
                  onTap: () {
                    // Navigate to details page or perform action
                    if (vegetables[index]['name'] ==
                        'Ampalaya (Bitter Melon)') {
                      Navigator.pushNamed(context, '/ampalaya');
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) => _onBottomNavItemTapped(context, index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.view_module),
            label: 'Modules',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'Forums',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Updates',
          ),
        ],
      ),
    );
  }
}
