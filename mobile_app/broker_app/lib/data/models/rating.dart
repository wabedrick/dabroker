import 'package:broker_app/data/models/user.dart';

class Rating {
  final int? id;
  final int rating;
  final String? review;
  final User? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Rating({
    this.id,
    required this.rating,
    this.review,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'] as int?,
      rating: json['rating'] as int,
      review: json['review'] as String?,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
}
