import 'package:flutter/material.dart';

class TypeOfCropsScreen extends StatefulWidget {
  const TypeOfCropsScreen({super.key});

  @override
  TypeOfCropsScreenState createState() => TypeOfCropsScreenState();
}

class TypeOfCropsScreenState extends State<TypeOfCropsScreen> {
  int _selectedIndex = 0;

  void _onBottomNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        // Navigate to Forums or other screen if needed
        break;
      case 2:
        // Navigate to Updates or other screen if needed
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Type of Crops"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              // Handle bookmark action
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Handle more options action
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          ListTile(
            leading: Image.asset(
              'images/vegetables.jpg',
              width: 150,
              height: 150,
            ),
            title: const Text('Vegetables'),
            subtitle: const Text('A plant or part of a plant used as food.'),
            trailing: const Icon(Icons.more_vert),
            onTap: () {
              Navigator.pushNamed(context, '/vegetables');
            },
          ),
          const Divider(),
          ListTile(
            leading: Image.asset(
              'images/fruits.jpg',
              width: 150,
              height: 150,
            ),
            title: const Text('Fruits'),
            subtitle: const Text(
                'The sweet and fleshy product of a tree or other plant that contains seed and can be eaten as food.'),
            trailing: const Icon(Icons.more_vert),
            onTap: () {
              // Handle tap action
            },
          ),
          const Divider(),
          ListTile(
            leading: Image.asset(
              'images/grains.jpg',
              width: 150,
              height: 150,
            ),
            title: const Text('Grains'),
            subtitle: const Text('A seed or fruit of a cereal grass.'),
            trailing: const Icon(Icons.more_vert),
            onTap: () {
              // Handle tap action
            },
          ),
          const Divider(),
          ListTile(
            leading: Image.asset(
              'images/legumes.jpg',
              width: 150,
              height: 150,
            ),
            title: const Text('Legumes'),
            subtitle: const Text(
                'The fruit or seed of leguminous plants (as peas or beans) used for food.'),
            trailing: const Icon(Icons.more_vert),
            onTap: () {
              // Handle tap action
            },
          ),
          const Divider(),
          ListTile(
            leading: Image.asset(
              'images/grass.jpg',
              width: 150,
              height: 150,
            ),
            title: const Text('Grass'),
            subtitle: const Text(
                'Green plants that grow in the ground, used as feed for animals or for lawns.'),
            trailing: const Icon(Icons.more_vert),
            onTap: () {
              // Handle tap action
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onBottomNavItemTapped,
        items: const [
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
