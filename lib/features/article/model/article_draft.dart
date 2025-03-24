import 'package:cloud_firestore/cloud_firestore.dart';
import 'country.dart';

class ArticleDraft {
  final String? id;
  final String? title;
  final String? description;
  final String? content;
  final String? coverImageBase64;
  final List<String> categories;
  final List<String> countries;
  final DateTime createdAt;
  final String userId;

  ArticleDraft({
    this.id,
    this.title,
    this.description,
    this.content,
    this.coverImageBase64,
    required this.categories,
    required this.countries,
    required this.createdAt,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'coverImageBase64': coverImageBase64,
      'categories': categories,
      'countries': countries,
      'createdAt': createdAt,
      'userId': userId,
    };
  }

  factory ArticleDraft.fromMap(Map<String, dynamic> map, String id) {
    return ArticleDraft(
      id: id,
      title: map['title'],
      description: map['description'],
      content: map['content'],
      coverImageBase64: map['coverImageBase64'],
      categories: List<String>.from(map['categories'] ?? []),
      countries: List<String>.from(map['countries'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      userId: map['userId'],
    );
  }
}
