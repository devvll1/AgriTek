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
      flags: YoutubePlayerFlags(
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

class Mango extends StatelessWidget {
  const Mango({super.key});

  @override
  Widget build(BuildContext context) {
    return const MangoDetailScreen();
  }
}

class MangoDetailScreen extends StatefulWidget {
  const MangoDetailScreen({super.key});

  @override
  MangoDetailScreenState createState() => MangoDetailScreenState();
}

class MangoDetailScreenState extends State<MangoDetailScreen> {

   final storage = FirebaseStorage.instance;
    // URLs for Firebase images
    late List<String> imageUrls;
    late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text:
          "A mango is a popular tropical fruit that is eaten in sweet and savory dishes around the world. It can be green, yellow, orange, red, or a combination of these colors, and has yellow or orange flesh surrounding a flat, hard pit. "
          );
    
    imageUrls = List.filled(15, ''); // Initialize with empty strings
    getImagesFromFirebase();
  }

 Future<void> getImagesFromFirebase() async {
    List<String> imageNames = [
      '1.png', '2.png', '3.png',
    ];

    for (int i = 0; i < imageNames.length; i++) {
      final ref = storage.ref().child('CropFarming/fruits/Mango/${imageNames[i]}');
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
        title: const Text('Fruits'),
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
                      'images/fruits/mango.jpg',
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
                            'Mango',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Mangifera indica',
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
              textAlign: TextAlign.left,
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
              '• Mango Seeds\n'
              '• Water\n'
              '• Paper Towel\n'
              '• Strong Scissor(Kitchen Shear)',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Step-by-Step Guide to Planting Mango:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStepCard(
                'Seed Preparation', imageUrls[0]),
                const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'a.  Cut open mango to remove seed. The seed will be inside a husk.\n'
                'b. Clean the seed husk.',                
                textAlign: TextAlign.left,
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
                'a. Using a pair of strong scissors, such as kitchen shears, carefully cut the edge of the seed husk, allowing you to open the husk and remove the seed. The seed will be slippery, so proceed with caution.\n'
                'b. Soak the seed in a cup of water for 24 hours.\n '
                'c. Moisten a paper towel. Make sure it is damp throughout, but not soaking wet. Wrap the seed in the paper towel.\n'
                'd. Place the seed and paper towel inside a sandwich bag, and store the seed in a warm place.\n'
                "e. Monitor the seed’s progress every few days, watching for sprouts. Germination time will depend on air temperature and the mango’s ripeness when the seed was extracted. ",
                textAlign: TextAlign.left,
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
                'a. Plant the seed in potting soil, making sure not to cover the new leaves.\n'
                'b. Water it Daily giving right amount of Water.',
                textAlign: TextAlign.left,
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
            GuideCard(videoId: 'L3mpeni4dHA'),
            GuideCard(videoId: 'ZGVPDvEzdh4'),
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
                    height: 250,
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
