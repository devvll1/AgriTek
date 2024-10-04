import 'package:flutter/material.dart';

class Ampalaya extends StatelessWidget {
  const Ampalaya({super.key});

  @override
  Widget build(BuildContext context) {
    // Remove MaterialApp from here
    return const AmpalayaDetailScreen();
  }
}

class AmpalayaDetailScreen extends StatefulWidget {
  const AmpalayaDetailScreen({super.key});

  @override
  AmpalayaDetailScreenState createState() => AmpalayaDetailScreenState();
}

class AmpalayaDetailScreenState extends State<AmpalayaDetailScreen> {
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text:
          "Ampalaya, or bitter melon, is a tropical fruit with a strong bitter flavor.The fruit has a distinctive warty exterior and an oblong shape. It is hollow in cross-section, with a relatively thin layer of flesh surrounding a central seed cavity filled with large, flat seeds and pith. The fruit is most often eaten green, or as it is beginning to turn yellow. At this stage, the fruit's flesh is crunchy and watery in texture, similar to cucumber, chayote, or green bell pepper, but bitter. The skin is tender and edible. Seeds and pith appear white in unripe fruits; they are not intensely bitter and can be removed before cooking. In traditional medicine, ampalaya is believed to offer health benefits like better blood sugar control and improved digestion, though scientific research is ongoing to confirm these effects.",
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _onBottomNavItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        // Handle other navigation items if needed
        break;
      case 2:
        // Handle other navigation items if needed
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vegetables'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Proper back navigation
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              // Add bookmark functionality here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Image.asset(
                      'images/Ampalaya.png',
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ampalaya (Bitter Melon)',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Momordica Charantia',
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Published date',
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _descriptionController.text,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Materials and Tools Needed:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Ampalaya Seeds\n'
              '• Fertilizer\n'
              '• Seedling Trays\n'
              '• Nylon Wires/Net\n'
              '• Insecticides\n'
              '• Fungicides\n'
              '• Fertilizer',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Step-by-Step Guide to Planting Ampalaya:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStepCard(
                'Step 1: Pre-Germinating the Seeds', 'images/1.png'),
                const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'The ampalaya seed coat is hard and waxy. It takes 7-8 days before the seed germinates. Emergence can be hastened by pre-germinating the seeds. An area of 1000 m2 (tenth of a hectare) requires about 120 g of seeds. One gram (g) contains around 5 seeds.\n',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
             _buildStepCard(
                '', 'images/2.png'),
                const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                ' a. Cut the longer tip of the seed with a nail cutter to facilitate absorption of water. ',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
            _buildStepCard('','images/3.png'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                ' b. Spread the seeds in a wet, clean cotton cloth for a more uniform absorption of moisture, and roll the cloth.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
           _buildStepCard(
                '', 'images/4.png'),
                const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                ' c. Incubate in a safe dark place until the radicles come out, which takes 2-3 days.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
             _buildStepCard(
                '', 'images/5.png'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'd.  Incubate in a safe dark place until the radicles come out, which takes 2-3 days.\n'
                'e. Wash the seeds everyday to prevent fungal growth. Seeds germinate easily at 250C to 300C (normal room temperature); longer when temperature is low or cold',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildStepCard(
                'Step 2: Preparing the Sowing Materials:', 'images/6.png'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'a. Prepare the following sowing medium.\n'
                '• 2 parts rice straw compost\n'
                '• 4 parts carbonized rice hull (CRH)\n'
                '• 1 part processed chicken manure (PCM)',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
            _buildStepCard(
                '', 'images/7.png'),
                const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                ' b. Mix the materials thoroughly.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),

            _buildStepCard(
                '', 'images/8.png'),
                const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                ' c. Fill the holes of the tray with the medium, and slightly compact it using your palm.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
            _buildStepCard(
                '', 'images/9.png'),
                const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                ' d. Use a seedling tray with 100 or 104 holes. The volume of medium in each hole contains enough nutrients to sustain the seedling until transplanting time.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
            _buildStepCard(
                'Step 3. Sowing', 'images/10.png'),
                const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                ' a. Sow one pre-germinated seed per hole of the plastic tray at a depth of 1.5 cm.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
            _buildStepCard(
                '', 'images/11.png'),
                const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                ' b. Cover the seed with enough medium. Cover the tray with old newspaper, plastic sack, or rice straw to maintain soil moisture and temperature.\n'
                'c. Remove the cover as soon as the seeds have sprouted.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),

            _buildStepCard(
                'Step 4. Caring for and maintaining the seedlings:', 'images/12.png'),
                const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'a. Place the trays on the platforms of a simple nursery.\n'
                'b. Roof the nursery with transparent plastic sheets during the rainy season; plastic nets or chicken wire during the dry season. The nursery minimizes exposure of the seedlings to extreme hot weather, heavy rains, and protects them from stray animals.\n'
                'c. Water early in the morning and afternoon. Apply less water during rainy and cloudy days. The seedlings weaken and elongate with too much water.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),

             _buildStepCard(
                '', 'images/13.png'),
                const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'd. Plant one seed per hill along the furrows at a distance of 30 to 50 cm between hills. Replant diseased and dead seedlings and missing hills 15 days after emergence.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const Text(
              'Explore More Guides',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildGuideCard('Ampalaya Farming: How to Grow Ampalaya',
                'Feb 15, 2016 - 4:45', 'images/guide1.png'),
            _buildGuideCard(
                'Ampalaya Farming: How to Grow Ampalaya or Bittergourd',
                'Feb 16, 2016 - 4:45',
                'images/guide2.png'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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

  Widget _buildStepCard(String stepTitle, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                stepTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Image.asset(
              imagePath,
              height: 150,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideCard(String title, String date, String imagePath) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Image.asset(
          imagePath,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        title: Text(title),
        subtitle: Text(date),
        onTap: () {
          // Handle guide tap
        },
      ),
    );
  }
}
