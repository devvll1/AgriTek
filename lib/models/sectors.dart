class Sector {
  final String id;
  final String name;
  final String description;
  final String? imageUrl; // Nullable field for image URL

  Sector({
    required this.id,
    required this.name,
    this.description = '',
    this.imageUrl,
  });

  factory Sector.fromJson(Map<String, dynamic> json) {
    return Sector(
      id: json['_id'],
      name: json['name'],
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'], // Update the imageUrl field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl, // Add the imageUrl field
    };
  }
}
