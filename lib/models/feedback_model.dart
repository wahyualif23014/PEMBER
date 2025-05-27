class FeedbackModel {
  final int id;
  final String userId;
  final String title;
  final String desctiption;
  final String location;
  final String image;
  final String rating;
  final DateTime createdAt;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.desctiption,
    required this.location,
    required this.image,
    required this.rating,
    required this.createdAt,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      desctiption: json['desctiption'],
      location: json['location'],
      image: json['image'],
      rating: json['rating'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
