import 'package:flutter/foundation.dart';

@immutable
class User {
  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.company,
    required this.city,
  });

  factory User.fromApiJson(Map<String, dynamic> json) {
    final address = json['address'] as Map<String, dynamic>? ?? {};
    final company = json['company'] as Map<String, dynamic>? ?? {};

    return User(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      website: json['website'] as String? ?? '',
      company: company['name'] as String? ?? '',
      city: address['city'] as String? ?? '',
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User.fromApiJson(json);
  }

  factory User.fromDatabaseRow(Map<String, Object?> row) {
    return User(
      id: row['id']! as int,
      name: row['name']! as String,
      username: row['username']! as String,
      email: row['email']! as String,
      phone: row['phone']! as String,
      website: row['website']! as String,
      company: row['company']! as String,
      city: row['city']! as String,
    );
  }

  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final String company;
  final String city;
}
