import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation based on the selected index
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        // Navigate to Forums or any other page
        break;
      case 2:
        Navigator.pushNamed(context, '/weather');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth < 600
        ? 2
        : 3; // Adjust number of columns based on screen width

    return Scaffold(
      appBar: AppBar(
        title: const Text('AgriTek'),
        leading: Builder(
          builder: (BuildContext context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the navigation drawer
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
          const CircleAvatar(
            child: Text('A'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'AgriTek',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            ListTile(
              title: const Text('Add Sector'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/modules');
              },
            ),
            ListTile(
              title: const Text('Forums'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Forums or any other page
              },
            ),
            ListTile(
              title: const Text('Updates'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Updates or any other page
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sectors of Agriculture',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  SectorCard(
                    title: 'Crop Farming',
                    subtitle: 'Production of Crops',
                    imageUrl: 'assets/images/cropfarming.jpg',
                    onTitlePressed: () {
                      Navigator.pushNamed(context, '/cropfarming');
                    },
                    screenWidth: screenWidth,
                  ),
                  SectorCard(
                    title: 'Forestry',
                    subtitle: 'Growing of Trees',
                    imageUrl: 'assets/images/forestry.jpg',
                    onTitlePressed: () {
                      Navigator.pushNamed(context, '/forestry');
                    },
                    screenWidth: screenWidth,
                  ),
                  SectorCard(
                    title: 'Fisheries and Aquaculture',
                    subtitle: 'Cultivating Aquatic Resources',
                    imageUrl: 'assets/images/fisheries.jpg',
                    onTitlePressed: () {
                      Navigator.pushNamed(context, '/aquaculture');
                    },
                    screenWidth: screenWidth,
                  ),
                  SectorCard(
                    title: 'Livestock',
                    subtitle: 'Raising of Domesticated Animals',
                    imageUrl: 'assets/images/livestock.jpeg',
                    onTitlePressed: () {
                      Navigator.pushNamed(context, '/livestock');
                    },
                    screenWidth: screenWidth,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
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

class SectorCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback onTitlePressed;
  final double screenWidth;

  const SectorCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTitlePressed,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8.0)),
              child: Image.asset(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextButton(
                  onPressed: onTitlePressed,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green[800],
                    padding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: screenWidth < 600 ? 15.0 : 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19.0),
                    ),
                    textStyle: TextStyle(
                      fontSize: screenWidth < 600 ? 12 : 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text(
                    title,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
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
