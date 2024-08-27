import 'package:flutter/material.dart';

class TypeOfCrops extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TypeOfCropsScreen();
  }
}

class TypeOfCropsScreen extends StatelessWidget {
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
              'assets/icons/vegetables.png', // Replace with your asset path
              width: 40,
              height: 40,
            ),
            title: Text('Vegetables'),
            subtitle: Text('A plant or part of a plant used as food.'),
            trailing: Icon(Icons.more_vert),
            onTap: () {
              // Handle tap action
            },
          ),
          Divider(),
          ListTile(
            leading: Image.asset(
              'assets/icons/fruits.png', // Replace with your asset path
              width: 40,
              height: 40,
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
              'assets/icons/grains.png', // Replace with your asset path
              width: 40,
              height: 40,
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
              'assets/icons/legumes.png', // Replace with your asset path
              width: 40,
              height: 40,
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
              'assets/icons/grass.png', // Replace with your asset path
              width: 40,
              height: 40,
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
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
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
