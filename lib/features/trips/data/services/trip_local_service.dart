import 'package:travel_map/features/trips/domain/models/trip.dart';
import 'package:travel_map/shared/app_database.dart';

class TripLocalService {
  const TripLocalService({required AppDatabase database})
    : _database = database;

  final AppDatabase _database;

  Future<List<Trip>> getTrips() async {
    final database = await _database.instance;
    final result = database.select(
      'SELECT * FROM trips ORDER BY updated_at DESC, title COLLATE NOCASE ASC;',
    );

    return [
      for (final row in result) Trip.fromDatabaseRow(row),
    ];
  }

  Future<DateTime?> getLastSyncedAt() async {
    final database = await _database.instance;
    final result = database.select(
      'SELECT MAX(updated_at) AS updated_at FROM trips;',
    );
    if (result.isEmpty || result.first['updated_at'] == null) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(
      result.first['updated_at']! as int,
    );
  }

  Future<void> upsertTrips(List<Trip> trips) async {
    final database = await _database.instance;
    final updatedAt = DateTime.now().millisecondsSinceEpoch;
    final statement = database.prepare('''
      INSERT INTO trips (
        id,
        title,
        owner_user_id,
        status,
        updated_at
      )
      VALUES (?, ?, ?, ?, ?)
      ON CONFLICT(id) DO UPDATE SET
        title = excluded.title,
        owner_user_id = excluded.owner_user_id,
        status = excluded.status,
        updated_at = excluded.updated_at;
    ''');

    try {
      database.execute('BEGIN TRANSACTION;');
      for (final trip in trips) {
        statement.execute([
          trip.id,
          trip.title,
          trip.ownerUserId,
          trip.status.name,
          updatedAt,
        ]);
      }
      database.execute('COMMIT;');
    } on Object {
      database.execute('ROLLBACK;');
      rethrow;
    } finally {
      statement.dispose();
    }
  }
}
