import 'package:flutter/foundation.dart';

enum TripStatus {
  planned,
  completed,
}

@immutable
class Trip {
  const Trip({
    required this.id,
    required this.title,
    required this.ownerUserId,
    required this.status,
  });

  factory Trip.fromApiJson(Map<String, dynamic> json) {
    final completed = json['completed'] as bool? ?? false;

    return Trip(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      ownerUserId: json['userId'] as int? ?? 0,
      status: completed ? TripStatus.completed : TripStatus.planned,
    );
  }

  factory Trip.fromDatabaseRow(Map<String, Object?> row) {
    return Trip(
      id: row['id']! as int,
      title: row['title']! as String,
      ownerUserId: row['owner_user_id']! as int,
      status: TripStatus.values.byName(row['status']! as String),
    );
  }

  final int id;
  final String title;
  final int ownerUserId;
  final TripStatus status;
}
