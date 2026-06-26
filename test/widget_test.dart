import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:travel_map/app.dart';
import 'package:travel_map/features/users/data/repositories/user_repository.dart';
import 'package:travel_map/features/users/domain/interactors/user_interactor.dart';
import 'package:travel_map/features/users/domain/models/user.dart';
import 'package:travel_map/shared/result.dart';

void main() {
  testWidgets('shows cached users before remote users', (tester) async {
    final localRepository = _FakeUserLocalRepository();
    final serverRepository = _FakeUserServerRepository();

    await tester.pumpWidget(
      Provider<UserInteractor>.value(
        value: UserInteractor(
          localRepository: localRepository,
          serverRepository: serverRepository,
        ),
        child: const MainApp(),
      ),
    );

    await tester.pump();

    expect(find.text('Users'), findsOneWidget);
    expect(find.text('Cached User'), findsOneWidget);
    expect(find.text('Local database'), findsOneWidget);
    expect(find.text('Syncing latest users...'), findsOneWidget);

    serverRepository.completeRemoteSync();
    await tester.pumpAndSettle();

    expect(find.text('Cached User'), findsNothing);
    expect(find.text('Remote User'), findsOneWidget);
    expect(find.text('API synced'), findsOneWidget);
  });
}

class _FakeUserLocalRepository implements UserLocalRepository {
  List<User> _users = const [
    User(
      id: 1,
      name: 'Cached User',
      username: 'Bret',
      email: 'cached@example.com',
      phone: '1-770-736-8031',
      website: 'hildegard.org',
      company: 'Romaguera-Crona',
      city: 'Gwenborough',
    ),
  ];

  @override
  Future<Result<List<User>>> getUsers() async {
    return Ok(_users);
  }

  @override
  Future<Result<DateTime?>> getLastSyncedAt() async {
    return const Ok(null);
  }

  @override
  Future<Result<void>> saveUsers(List<User> users) async {
    _users = users;
    return const Ok(null);
  }
}

class _FakeUserServerRepository implements UserServerRepository {
  final Completer<Result<List<User>>> _remoteSyncCompleter =
      Completer<Result<List<User>>>();

  @override
  Future<Result<List<User>>> getUsers() {
    return _remoteSyncCompleter.future;
  }

  void completeRemoteSync() {
    _remoteSyncCompleter.complete(
      const Ok([
        User(
          id: 1,
          name: 'Remote User',
          username: 'Antonette',
          email: 'remote@example.com',
          phone: '010-692-6593',
          website: 'anastasia.net',
          company: 'Deckow-Crist',
          city: 'Wisokyburgh',
        ),
      ]),
    );
  }
}
