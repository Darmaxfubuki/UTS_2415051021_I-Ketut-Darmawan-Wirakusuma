class SavedMountainModel {
  final String id;
  final String mountainId;
  final String mountainName;
  final String userNote;
  final int personalRating;
  final DateTime createdAt;

  const SavedMountainModel({
    required this.id,
    required this.mountainId,
    required this.mountainName,
    required this.userNote,
    required this.personalRating,
    required this.createdAt,
  });

  factory SavedMountainModel.fromJson(Map<String, dynamic> json) {
    return SavedMountainModel(
      id: json['id']?.toString() ?? '',
      mountainId: json['mountain_id']?.toString() ?? '',
      mountainName: json['mountain_name'] as String? ?? '',
      userNote: json['user_note'] as String? ?? '',
      personalRating: (json['personal_rating'] as num?)?.toInt() ?? 5,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mountain_id': mountainId,
      'mountain_name': mountainName,
      'user_note': userNote,
      'personal_rating': personalRating,
      'created_at': createdAt.toIso8601String(),
    };
  }
}