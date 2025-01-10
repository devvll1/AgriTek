import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;

class ForumsPage extends StatefulWidget {
  const ForumsPage({super.key});

  @override
  _ForumsPageState createState() => _ForumsPageState();
}

class _ForumsPageState extends State<ForumsPage> {
  final _postController = TextEditingController();
  final _commentController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;
  final Map<String, String> _userCache = {}; // Cache for user names

  @override
  void dispose() {
    _postController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<String> _getFullName(String? userId) async {
    if (userId == null) return 'Anonymous';

    if (_userCache.containsKey(userId)) {
      return _userCache[userId]!;
    }

    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final data = userDoc.data();
        final fullName = '${data?['firstName'] ?? ''} ${data?['lastName'] ?? ''}'.trim();
        _userCache[userId] = fullName;
        return fullName.isNotEmpty ? fullName : 'Anonymous';
      }
    } catch (e) {}

    return 'Anonymous';
  }

  Future<void> _addPost() async {
    if (_postController.text.trim().isEmpty) return;

    await FirebaseFirestore.instance.collection('posts').add({
      'content': _postController.text.trim(),
      'author': user?.uid,
      'timestamp': FieldValue.serverTimestamp(),
      'likes': [],
    });
    _postController.clear();
  }

  Future<void> _addComment(String postId) async {
    if (_commentController.text.trim().isEmpty) return;

    await FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').add({
      'content': _commentController.text.trim(),
      'author': user?.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
    _commentController.clear();
  }

  Future<void> _toggleLike(String postId, List<dynamic> currentLikes) async {
    final userId = user?.uid;
    if (userId == null) return;

    if (currentLikes.contains(userId)) {
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([userId]),
      });
    } else {
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  void _showPostDetails(String postId, Map<String, dynamic> postData) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: FutureBuilder<String>(
            future: _getFullName(postData['author']),
            builder: (context, authorSnapshot) {
              final authorName = authorSnapshot.data ?? 'Anonymous';
              return StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authorName,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(postData['content']),
                          ],
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(postId)
                            .collection('comments')
                            .orderBy('timestamp', descending: false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final comments = snapshot.data!.docs;

                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final commentData = comments[index].data() as Map<String, dynamic>;
                              final timestamp = commentData['timestamp'] as Timestamp?;
                              final commentTime =
                                  timestamp != null ? timeago.format(timestamp.toDate()) : '';
                              return FutureBuilder<String>(
                                future: _getFullName(commentData['author']),
                                builder: (context, commenterSnapshot) {
                                  final commenterName = commenterSnapshot.data ?? 'Anonymous';
                                  return ListTile(
                                    title: Text(commenterName),
                                    subtitle: Text('${commentData['content']} ($commentTime)'),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _commentController,
                                decoration:
                                    const InputDecoration(hintText: 'Write a comment...'),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () => _addComment(postId),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    postData['likes'].contains(user?.uid)
                                        ? Icons.thumb_up
                                        : Icons.thumb_up_alt_outlined,
                                    color: postData['likes'].contains(user?.uid)
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                  onPressed: () {
                                    _toggleLike(postId, postData['likes']);
                                    setState(() {
                                      if (postData['likes'].contains(user?.uid)) {
                                        postData['likes'].remove(user?.uid);
                                      } else {
                                        postData['likes'].add(user?.uid);
                                      }
                                    });
                                  },
                                ),
                                Text('${postData['likes'].length} Likes'),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.comment, size: 20, color: Colors.grey),
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('posts')
                                      .doc(postId)
                                      .collection('comments')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    final commentCount = snapshot.hasData
                                        ? snapshot.data!.docs.length
                                        : 0;
                                    return Text(' $commentCount Comments');
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forums'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _postController,
                    decoration: const InputDecoration(
                      hintText: 'What\'s on your mind?',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addPost,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final posts = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final postId = post.id;
                    final postData = post.data() as Map<String, dynamic>;
                    final likes = postData['likes'] ?? [];
                    final timestamp = postData['timestamp'] as Timestamp?;
                    final dateTime = timestamp != null ? timestamp.toDate() : DateTime.now();
                    final formattedTime = timeago.format(dateTime);

                    return GestureDetector(
                      onTap: () => _showPostDetails(postId, postData),
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<String>(
                                future: _getFullName(postData['author']),
                                builder: (context, snapshot) {
                                  final authorName = snapshot.data ?? 'Anonymous';
                                  return Text(
                                    authorName,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                              Text(postData['content']),
                              const SizedBox(height: 10),
                              Text(
                                'Posted $formattedTime',
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          likes.contains(user?.uid)
                                              ? Icons.thumb_up
                                              : Icons.thumb_up_alt_outlined,
                                          color: likes.contains(user?.uid)
                                              ? Colors.blue
                                              : Colors.grey,
                                        ),
                                        onPressed: () => _toggleLike(postId, likes),
                                      ),
                                      Text('${likes.length}'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.comment, size: 20, color: Colors.grey),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('posts')
                                            .doc(postId)
                                            .collection('comments')
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          final commentCount = snapshot.hasData
                                              ? snapshot.data!.docs.length
                                              : 0;
                                          return Text(' $commentCount');
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
