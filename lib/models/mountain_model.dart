class MountainModel {
  final String id;
  final String name;
  final String location;
  final int elevation;
  final double rating;
  final String imageUrl;
  final String description;
  final String estimatedTime;
  final String difficulty;

  const MountainModel({
    required this.id,
    required this.name,
    required this.location,
    required this.elevation,
    required this.rating,
    required this.imageUrl,
    required this.description,
    this.estimatedTime = '4 - 6 Jam',
    this.difficulty = 'Menengah',
  });

  factory MountainModel.fromJson(Map<String, dynamic> json) {
    return MountainModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      elevation: (json['elevation'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] as String? ?? '',
      description: json['description'] as String? ?? '',
      estimatedTime: json['estimatedTime'] as String? ?? '4 - 6 Jam',
      difficulty: json['difficulty'] as String? ?? 'Menengah',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'elevation': elevation,
      'rating': rating,
      'imageUrl': imageUrl,
      'description': description,
      'estimatedTime': estimatedTime,
      'difficulty': difficulty,
    };
  }
}