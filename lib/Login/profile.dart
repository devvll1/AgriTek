import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  String? selectedFarmerType;

  Map<String, dynamic>? userData;
  bool isLoading = true;

  File? _profileImage; // To store the picked image
  final ImagePicker _imagePicker = ImagePicker();

  final List<String> farmerTypes = [
    'Crop Farmer',
    'Livestock Farmer',
    'Aquaculture Farmer',
    'Agroforestry Farmer',
    'Mixed Farmer'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in.')),
        );
        return;
      }

      final snapshot =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (snapshot.exists) {
        setState(() {
          userData = snapshot.data();
          _initializeControllers();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile data not found.')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    }
  }

  void _initializeControllers() {
    _controllers['firstName'] = TextEditingController(text: userData?['firstName']);
    _controllers['middleName'] =
        TextEditingController(text: userData?['middleName'] ?? '');
    _controllers['lastName'] = TextEditingController(text: userData?['lastName']);
    _controllers['age'] = TextEditingController(text: userData?['age']);
    _controllers['address'] = TextEditingController(text: userData?['address']);
    selectedFarmerType = userData?['farmerType'];
  }

  Future<void> _pickImage() async {
  // Request storage permissions
  final status = await Permission.storage.request();

  if (status.isGranted) {
    // If permission is granted, pick an image
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  } else if (status.isDenied) {
    // If permission is denied, show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Storage permission is required to pick an image.')),
    );
  } else if (status.isPermanentlyDenied) {
    // If permission is permanently denied, prompt the user to enable it in settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enable storage permission in settings.')),
    );
    await openAppSettings();
  }
}

  Future<String?> _uploadImageAndSaveProfile(String userId) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$userId.jpg');

      final uploadTask = await storageRef.putFile(_profileImage!);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
      return null;
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true; // Show a loading indicator while saving
    });

    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in.')),
        );
        return;
      }

      // Collect updated data
      final updatedData = {
        'firstName': _controllers['firstName']!.text.trim(),
        'middleName': _controllers['middleName']!.text.trim(),
        'lastName': _controllers['lastName']!.text.trim(),
        'age': _controllers['age']!.text.trim(),
        'address': _controllers['address']!.text.trim(),
        'farmerType': selectedFarmerType,
      };

      // Update the profile image if there's a new image
      if (_profileImage != null) {
        final profileImageUrl = await _uploadImageAndSaveProfile(user.uid);
        if (profileImageUrl != null) {
          updatedData['profileImageUrl'] = profileImageUrl;
        }
      }

      // Update Firestore with all user data
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(updatedData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Profile'),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
              ? const Center(child: Text('No profile data available.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          'Edit Your Profile',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : (userData?['profileImageUrl'] != null
                                    ? NetworkImage(userData!['profileImageUrl'])
                                    : const AssetImage('assets/images/defaultprofile.png'))
                                    as ImageProvider,
                            child: _profileImage == null
                                ? const Icon(
                                    CupertinoIcons.camera,
                                    size: 40,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView(
                            children: [
                              _buildEditableField('First Name', 'firstName'),
                              _buildEditableField('Middle Name', 'middleName'),
                              _buildEditableField('Last Name', 'lastName'),
                              _buildEditableField('Age', 'age'),
                              _buildEditableField('Address', 'address'),
                              _buildDropdownField('Farmer Type'),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _saveChanges,
                          icon: const Icon(CupertinoIcons.check_mark),
                          label: const Text(
                            'Save Changes',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildEditableField(String label, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFormField(
          controller: _controllers[key],
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label cannot be empty';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonFormField<String>(
          value: selectedFarmerType,
          items: farmerTypes
              .map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedFarmerType = value;
            });
          },
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label cannot be empty';
            }
            return null;
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
