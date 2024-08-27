import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    theme: ThemeData(
      primaryColor: Colors.green, // Matching the purple header color
    ),
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AgriTek'),
        leading: Icon(Icons.menu),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
          CircleAvatar(
            child: Text('A'),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sectors of Agriculture',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  SectorCard(
                    title: 'Crop Farming',
                    subtitle: 'Production of Crops',
                    imageUrl: 'assets/images/cropfarming.jpg', // Local asset path
                    onTitlePressed: () {
                      // Handle Crop Farming title button press
                      print('Crop Farming button pressed');
                      Navigator.pushNamed(context, '/cropfarming');
                    },
                  ),
                  SectorCard(
                    title: 'Forestry',
                    subtitle: 'Growing of Trees',
                    imageUrl: 'assets/images/forestry.jpg', // Local asset path
                    onTitlePressed: () {
                      // Handle Forestry title button press
                      print('Forestry button pressed');
                       Navigator.pushNamed(context, '/cropfarming');
                    },
                  ),
                  SectorCard(
                    title: 'Fisheries and Aquaculture',
                    subtitle: 'Cultivating Aquatic Resources',
                    imageUrl: 'assets/images/fisheries.jpg', // Local asset path
                    onTitlePressed: () {
                      // Handle Fisheries button press
                      print('Fisheries button pressed');
                    },
                  ),
                  SectorCard(
                    title: 'Livestock',
                    subtitle: 'Raising of Domesticated Animals',
                    imageUrl: 'assets/images/livestock.jpeg', // Local asset path
                    onTitlePressed: () {
                      // Handle Livestock button press
                      print('Livestock button pressed');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // Set the background color to green
        selectedItemColor: Colors.green, // Set the color of the selected item to white
        unselectedItemColor: Colors.grey, // Set the color of unselected items to a lighter shade of white
       
        items: [
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

  const SectorCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTitlePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300], // Background color for the cards
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
            child: imageUrl.startsWith('http') || imageUrl.startsWith('https')
                ? Image.network(
                    imageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    imageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: TextButton(
                    onPressed: onTitlePressed,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white, // Text color when not hovered
                      backgroundColor: Colors.green[800], // Background color when not hovered
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19.0),
                      ),
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text(
                      title,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54, // Grey color for subtitles
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
