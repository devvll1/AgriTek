import 'package:flutter/material.dart';

class TypeOfCrops extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TypeOfCropsScreen();
  }
}

class TypeOfCropsScreen extends StatefulWidget {
  @override
  _TypeOfCropsScreenState createState() => _TypeOfCropsScreenState();
}

class _TypeOfCropsScreenState extends State<TypeOfCropsScreen> {
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
        title: Text("Type of Crops"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
          IconButton(
            icon: Icon(Icons.bookmark_border),
            onPressed: () {
              // Handle bookmark action
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
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
            title: Text('Vegetables'),
            subtitle: Text('A plant or part of a plant used as food.'),
            trailing: Icon(Icons.more_vert),
            onTap: () {
              Navigator.pushNamed(context, '/vegetables');
            },
          ),
          Divider(),
          ListTile(
            leading: Image.asset(
              'images/fruits.jpg',
              width: 150,
              height: 150,
            ),
            title: Text('Fruits'),
            subtitle: Text(
                'The sweet and fleshy product of a tree or other plant that contains seed and can be eaten as food.'),
            trailing: Icon(Icons.more_vert),
            onTap: () {
              // Handle tap action
            },
          ),
          Divider(),
          ListTile(
            leading: Image.asset(
              'images/grains.jpg',
              width: 150,
              height: 150,
            ),
            title: Text('Grains'),
            subtitle: Text('A seed or fruit of a cereal grass.'),
            trailing: Icon(Icons.more_vert),
            onTap: () {
              // Handle tap action
            },
          ),
          Divider(),
          ListTile(
            leading: Image.asset(
              'images/legumes.jpg',
              width: 150,
              height: 150,
            ),
            title: Text('Legumes'),
            subtitle: Text(
                'The fruit or seed of leguminous plants (as peas or beans) used for food.'),
            trailing: Icon(Icons.more_vert),
            onTap: () {
              // Handle tap action
            },
          ),
          Divider(),
          ListTile(
            leading: Image.asset(
              'images/grass.jpg',
              width: 150,
              height: 150,
            ),
            title: Text('Grass'),
            subtitle: Text(
                'Green plants that grow in the ground, used as feed for animals or for lawns.'),
            trailing: Icon(Icons.more_vert),
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
