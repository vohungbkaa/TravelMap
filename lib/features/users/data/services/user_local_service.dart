import 'package:travel_map/features/users/domain/models/user.dart';
import 'package:travel_map/shared/app_database.dart';

class UserLocalService {
  const UserLocalService({required AppDatabase database})
    : _database = database;

  final AppDatabase _database;

  Future<List<User>> getUsers() async {
    final database = await _database.instance;
    final result = database.select(
      'SELECT * FROM users ORDER BY name COLLATE NOCASE ASC;',
    );

    return [
      for (final row in result) User.fromDatabaseRow(row),
    ];
  }

  Future<DateTime?> getLastSyncedAt() async {
    final database = await _database.instance;
    final result = database.select(
      'SELECT MAX(updated_at) AS updated_at FROM users;',
    );
    if (result.isEmpty || result.first['updated_at'] == null) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(
      result.first['updated_at']! as int,
    );
  }

  Future<void> upsertUsers(List<User> users) async {
    final database = await _database.instance;
    final updatedAt = DateTime.now().millisecondsSinceEpoch;
    final statement = database.prepare('''
      INSERT INTO users (
        id,
        name,
        username,
        email,
        phone,
        website,
        company,
        city,
        updated_at
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT(id) DO UPDATE SET
        name = excluded.name,
        username = excluded.username,
        email = excluded.email,
        phone = excluded.phone,
        website = excluded.website,
        company = excluded.company,
        city = excluded.city,
        updated_at = excluded.updated_at;
    ''');

    try {
      database.execute('BEGIN TRANSACTION;');
      for (final user in users) {
        statement.execute([
          user.id,
          user.name,
          user.username,
          user.email,
          user.phone,
          user.website,
          user.company,
          user.city,
          updatedAt,
        ]);
      }
      database.execute('COMMIT;');
    } catch (_) {
      database.execute('ROLLBACK;');
      rethrow;
    } finally {
      statement.dispose();
    }
  }
}
