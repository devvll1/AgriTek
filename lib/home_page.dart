import 'package:flutter/material.dart';
import 'package:agritek/Authentication/auth.dart';

// Custom Search Delegate
class CustomSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> searchItems = [
    {'title': 'Mango', 'route': '/mango'},
    {'title': 'Crop Farming', 'route': '/cropfarming'},
    {'title': 'Forestry', 'route': '/forestry'},
    {'title': 'Fisheries and Aquaculture', 'route': '/aquaculture'},
    {'title': 'Livestock', 'route': '/livestock'},
    {'title': 'Upo', 'route': '/upo'},
    {'title': 'Ampalaya', 'route': '/ampalaya'},
    {'title': 'Chicken', 'route': '/chicken'},
    {'title': 'Corn', 'route': '/corn'},
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = searchItems
        .where((item) => item['title'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]['title']),
          onTap: () => Navigator.pushNamed(context, results[index]['route']),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = searchItems
        .where((item) => item['title'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]['title']),
          onTap: () {
            query = suggestions[index]['title'];
            showResults(context);
          },
        );
      },
    );
  }
}

// Main Application
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

// Home Page
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/forums');
        break;
      case 2:
        Navigator.pushNamed(context, '/weather');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth < 600 ? 2 : 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AgriTek'),
        leading: Builder(
          builder: (BuildContext context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearch(
              context: context,
              delegate: CustomSearchDelegate(),
            ),
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
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                'AgriTek',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            ListTile(
              title: const Text('Forums'),
              onTap: () => Navigator.pushNamed(context, '/forums'),
            ),
            ListTile(
              title: const Text('Updates'),
              onTap: () => Navigator.pushNamed(context, '/weather'),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                Navigator.pop(context);
                await widget.signOut();
                Navigator.pushReplacementNamed(context, '/login');
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
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                    onTitlePressed: () => Navigator.pushNamed(context, '/cropfarming'),
                    screenWidth: screenWidth,
                  ),
                  SectorCard(
                    title: 'Forestry',
                    subtitle: 'Growing of Trees',
                    imageUrl: 'assets/images/forestry.jpg',
                    onTitlePressed: () => Navigator.pushNamed(context, '/forestry'),
                    screenWidth: screenWidth,
                  ),
                  SectorCard(
                    title: 'Fisheries and Aquaculture',
                    subtitle: 'Cultivating Aquatic Resources',
                    imageUrl: 'assets/images/fisheries.jpg',
                    onTitlePressed: () => Navigator.pushNamed(context, '/aquaculture'),
                    screenWidth: screenWidth,
                  ),
                  SectorCard(
                    title: 'Livestock',
                    subtitle: 'Raising of Domesticated Animals',
                    imageUrl: 'assets/images/livestock.jpeg',
                    onTitlePressed: () => Navigator.pushNamed(context, '/livestock'),
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
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Modules'),
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'Forums'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Updates'),
        ],
      ),
    );
  }
}

// SectorCard Widget
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
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
                      horizontal: screenWidth < 600 ? 15.0 : 20.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19.0),
                    ),
                    textStyle: TextStyle(
                      fontSize: screenWidth < 600 ? 12 : 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text(title),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
