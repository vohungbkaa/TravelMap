import 'dart:async';

import 'package:logging/logging.dart';
import 'package:travel_map/features/users/domain/interactors/user_interactor.dart';
import 'package:travel_map/features/users/domain/models/user.dart';
import 'package:travel_map/shared/command.dart';
import 'package:travel_map/shared/result.dart';
import 'package:travel_map/shared/safe_change_notifier.dart';

enum UsersDataSource { local, remote }

class UsersViewModel extends SafeChangeNotifier {
  UsersViewModel(this._userInteractor, this._log) {
    load = Command0(_load);
    refresh = Command0(_refresh);
    unawaited(load.execute());
  }

  final UserInteractor _userInteractor;
  final Logger _log;

  late final Command0<void> load;
  late final Command0<void> refresh;

  List<User> _users = [];
  List<User> get users => _users;

  UsersDataSource _source = UsersDataSource.local;
  UsersDataSource get source => _source;

  DateTime? _lastSyncedAt;
  DateTime? get lastSyncedAt => _lastSyncedAt;

  bool _syncing = false;
  bool get syncing => _syncing;

  Object? _syncError;
  Object? get syncError => _syncError;

  bool get isEmpty => _users.isEmpty;

  Future<Result<void>> _load() async {
    await _reloadFromLocal();
    unawaited(_refresh());
    return const Ok(null);
  }

  Future<void> _reloadFromLocal() async {
    final cachedResult = await _userInteractor.getLocalUsers();
    if (isDisposed) {
      return;
    }
    switch (cachedResult) {
      case Ok<List<User>>():
        _users = cachedResult.value;
        _source = _source == UsersDataSource.remote
            ? UsersDataSource.remote
            : UsersDataSource.local;
        await _loadLastSyncedAt();
        if (isDisposed) {
          return;
        }
      case Error<List<User>>():
        _syncError = cachedResult.error;
        _log.warning('Failed to reload local users', cachedResult.error);
    }

    notifyListeners();
  }

  Future<Result<void>> _refresh() async {
    if (isDisposed) {
      return const Ok(null);
    }
    _syncing = true;
    _syncError = null;
    notifyListeners();

    final result = await _userInteractor.syncUsers();
    if (isDisposed) {
      return const Ok(null);
    }
    _syncing = false;

    switch (result) {
      case Ok<List<User>>():
        _users = result.value;
        _source = UsersDataSource.remote;
        await _loadLastSyncedAt();
        if (isDisposed) {
          return const Ok(null);
        }
      case Error<List<User>>():
        _syncError = result.error;
        _log.warning('Keeping cached users after sync failure', result.error);
    }

    notifyListeners();
    return switch (result) {
      Ok<List<User>>() => const Ok(null),
      Error<List<User>>() => Error(result.error, result.stackTrace),
    };
  }

  Future<void> _loadLastSyncedAt() async {
    final result = await _userInteractor.getLastSyncedAt();
    if (isDisposed) {
      return;
    }
    switch (result) {
      case Ok<DateTime?>():
        _lastSyncedAt = result.value;
      case Error<DateTime?>():
        _log.warning('Failed to load last sync time', result.error);
    }
  }

  @override
  void dispose() {
    load.dispose();
    refresh.dispose();
    super.dispose();
  }
}
