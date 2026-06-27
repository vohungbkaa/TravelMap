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

  // Map dữ liệu từ API GitHub về các cột SQLite tương ứng để không phải đổi Schema
  factory User.fromApiJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['login'] as String? ?? '',
      username: json['login'] as String? ?? '',
      email: json['html_url'] as String? ?? '', // Dùng html_url thay cho email
      phone: json['type'] as String? ?? 'User',  // Dùng type (User/Organization) cho phone
      website: json['avatar_url'] as String? ?? '', // Dùng avatar_url cho website
      company: 'GitHub Inc',
      city: 'Open Source',
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
