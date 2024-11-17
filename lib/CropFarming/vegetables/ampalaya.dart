import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GuideCard extends StatefulWidget {
  final String videoId;

  const GuideCard({super.key, required this.videoId});

  @override
  _GuideCardState createState() => _GuideCardState();
}

class _GuideCardState extends State<GuideCard> {
  String title = 'Loading...';
  String publishedDate = 'Loading...';
  String runtime = 'Loading...';

  @override
  void initState() {
    super.initState();
    fetchVideoDetails(widget.videoId);
  }

  Future<void> fetchVideoDetails(String videoId) async {
    const String apiKey = 'AIzaSyCiu2BV_raUsRj2X9ZJxohqzdxXJlUiGQU';
    final String url = 'https://www.googleapis.com/youtube/v3/videos?part=snippet,contentDetails&id=$videoId&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final videoInfo = data['items'][0];

        setState(() {
          title = videoInfo['snippet']['title'];
          publishedDate = videoInfo['snippet']['publishedAt'].substring(0, 10); // Extracting date part
          runtime = _convertDuration(videoInfo['contentDetails']['duration']);
        });
      } else {
        throw Exception('Failed to load video details');
      }
    } catch (e) {
      print('Error fetching video details: $e');
    }
  }

  // Helper function to convert ISO 8601 duration (e.g., PT4M13S) to a readable format (e.g., 4:13)
  String _convertDuration(String isoDuration) {
    final regex = RegExp(r'PT(\d+H)?(\d+M)?(\d+S)?');
    final match = regex.firstMatch(isoDuration);

    if (match == null) return 'Unknown';

    final hours = match.group(1) != null ? int.parse(match.group(1)!.replaceAll('H', '')) : 0;
    final minutes = match.group(2) != null ? int.parse(match.group(2)!.replaceAll('M', '')) : 0;
    final seconds = match.group(3) != null ? int.parse(match.group(3)!.replaceAll('S', '')) : 0;

    final formattedMinutes = minutes.toString().padLeft(2, '0');
    final formattedSeconds = seconds.toString().padLeft(2, '0');
    return hours > 0 ? '$hours:$formattedMinutes:$formattedSeconds' : '$formattedMinutes:$formattedSeconds';
  }

  @override
  Widget build(BuildContext context) {
    String thumbnailUrl = 'https://img.youtube.com/vi/${widget.videoId}/0.jpg';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Image.network(
          thumbnailUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        title: Text(title),
        subtitle: Text('Published on $publishedDate\nDuration: $runtime'),
        onTap: () {
          _showYoutubePlayerDialog(widget.videoId);
        },
      ),
    );
  }

  void _showYoutubePlayerDialog(String videoId) {
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            onReady: () {
              print('Player is ready.');
            },
          ),
        );
      },
    );
  }
}

class Ampalaya extends StatelessWidget {
  const Ampalaya({super.key});

  @override
  Widget build(BuildContext context) {
    return const AmpalayaDetailScreen();
  }
}

class AmpalayaDetailScreen extends StatefulWidget {
  const AmpalayaDetailScreen({super.key});

  @override
  AmpalayaDetailScreenState createState() => AmpalayaDetailScreenState();
}

class AmpalayaDetailScreenState extends State<AmpalayaDetailScreen> {

   final storage = FirebaseStorage.instance;
    // URLs for Firebase images
    late List<String> imageUrls;
    late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text:
          "Ampalaya, or bitter melon, is a tropical fruit with a strong bitter flavor.The fruit has a distinctive warty exterior and an oblong shape. It is hollow in cross-section, with a relatively thin layer of flesh surrounding a central seed cavity filled with large, flat seeds and pith. The fruit is most often eaten green, or as it is beginning to turn yellow. At this stage, the fruit's flesh is crunchy and watery in texture, similar to cucumber, chayote, or green bell pepper, but bitter. The skin is tender and edible. Seeds and pith appear white in unripe fruits; they are not intensely bitter and can be removed before cooking. In traditional medicine, ampalaya is believed to offer health benefits like better blood sugar control and improved digestion, though scientific research is ongoing to confirm these effects.",
    );
    
    imageUrls = List.filled(15, ''); // Initialize with empty strings
    getImagesFromFirebase();
  }

 Future<void> getImagesFromFirebase() async {
    List<String> imageNames = [
      '1.png', '2.png', '3.png', '4.png', '5.png',
      '6.png', '7.png', '8.png', '9.png', '10.png', '11.png', '12.png',
      '13.png', '14.png', '15.png',
    ];

    for (int i = 0; i < imageNames.length; i++) {
      final ref = storage.ref().child('CropFarming/vegetables/Ampalaya/${imageNames[i]}');
      final url = await ref.getDownloadURL();
      setState(() {
        imageUrls[i] = url;
      });
    }
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
                      'images/vegetables/Ampalaya.png',
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
                'Step 1: Pre-Germinating the Seeds', imageUrls[0]),
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
                '', imageUrls[1]),
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
            _buildStepCard('',imageUrls[2]),
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
                '', imageUrls[3]),
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
                '', imageUrls[4]),
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
                'Step 2: Preparing the Sowing Materials:', imageUrls[5]),
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
                '', imageUrls[6]),
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
                '', imageUrls[7]),
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
                '', imageUrls[8]),
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
                'Step 3. Sowing', imageUrls[9]),
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
                '', imageUrls[10]),
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
                'Step 4. Caring for and maintaining the seedlings:', imageUrls[11]),
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
                '', imageUrls[12]),
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

            _buildStepCard(
                'Step 5. Transplanting', imageUrls[13]),
                const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'a. Use potlets or seedling trays to grow seedlings.\n'
                'b. Prepare and mix thoroughly potting medium of 1:1:1 garden soil, Carbonized Rice Hull (CRH) and compost.\n'
                'c. Fill the container with mix media.\n'
                'd. Plant one seed per potlet or tray hole filled with a prepared planting media.\n'
                'e. When the seedlings emerge, water the plants regularly when needed. \n'
                'f.  When the seedlings are grown, harden them by gradually reducing water application and by exposing them under the sun.\n'
                'g. Transplant at 15 days after sowing or when true leaves have developed. Do not delay transplanting because this will result to poor plant growth and high mortality. \n'
                 'Transplant late in the afternoon for higher percentage recovery of seedlings.\n'
                'h.  Apply starter solution by dissolving one tbsp of urea (46-0-0) to 6 liters of water and use as drench for seedlings at transplanting. After drenching, the seedlings should be sprinkled with clean water immediately to avoid burning effects.\n',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),

            _buildTitleCard(
                'Fertilizer Application'),
                const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                ' a. Apply 10 to 20 tons organic fertilizer per hectare or decomposed animal manure or compost before field preparation to supplement inorganic fertilizer. At planting, apply complete fertilizer (14- 14-14) at the rate of 20 grams or two tbsp per hill. Sidedress with urea at the rate of 10 grams or one tbsp per hill before hilling up (3 to 4 weeks from planting). Repeat application every 2 weeks for at least 2 to 3 times more. Cover the fertilizer with at least 6 cm of soil after application.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),

            _buildTitleCard(
                'Irrigation'),
                const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                ' a. Irrigate the field when necessary during the growing period of the plant. Furrow irrigation can be applied. Ampalaya cannot tolerate water logging hence a drainage canal should be provided.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),

            _buildStepCard(
                'Pruning', imageUrls[14]),
                const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'a. Remove all lateral vines and old leaves from the base up to 1 m above so that nutrients are concentrated on the fruiting branches and fruits. Maintain single or two lateral vines only. This will enhance fruiting ability of the plants with bigger and quality fruits. Cut lateral vines can be sold in the market at a good price for an additional income.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),

            _buildTitleCard(
                'Cultivation and Weeding'),
                const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Off-bar the plants at 7 to 10 days after planting to control weeds. Hill up at 15 to 20 days after off-barring or during the application of sidedress fertilizers. Hand weed the base of the plants regularly to avoid the weeds competing with plants in nutrient and water uptake.',
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
            const GuideCard(videoId: '0D-2BCZyN1E'),
            const GuideCard(videoId: 'BBuTWmSIpnY'),
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

  Widget _buildStepCard(String stepTitle, String imageUrl) {
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
          imageUrl.isNotEmpty
              ? Container(
                  width: double.infinity, // Fill the width of the device
                  child: Image.network(  
                    imageUrl,
                    height: 200,
                    fit: BoxFit.cover, // Adjust this to fit your needs
                  ),
                )
              : const SizedBox(
                  height: 150,
                  child: Center(child: CircularProgressIndicator()),
                ),
        ],
      ),
    )
   );
  }
}


  Widget _buildTitleCard(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
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
