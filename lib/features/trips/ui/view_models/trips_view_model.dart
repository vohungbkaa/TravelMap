import 'dart:async';

import 'package:logging/logging.dart';
import 'package:travel_map/features/trips/domain/interactors/trip_interactor.dart';
import 'package:travel_map/features/trips/domain/models/trip.dart';
import 'package:travel_map/shared/command.dart';
import 'package:travel_map/shared/result.dart';
import 'package:travel_map/shared/safe_change_notifier.dart';

enum TripsDataSource { local, remote }

class TripsViewModel extends SafeChangeNotifier {
  TripsViewModel(this._tripInteractor, this._log) {
    load = Command0(_load);
    refresh = Command0(_refresh);
    unawaited(load.execute());
  }

  final TripInteractor _tripInteractor;
  final Logger _log;

  late final Command0<void> load;
  late final Command0<void> refresh;

  List<Trip> _trips = [];
  List<Trip> get trips => _trips;

  TripsDataSource _source = TripsDataSource.local;
  TripsDataSource get source => _source;

  DateTime? _lastSyncedAt;
  DateTime? get lastSyncedAt => _lastSyncedAt;

  bool _syncing = false;
  bool get syncing => _syncing;

  Object? _syncError;
  Object? get syncError => _syncError;

  bool get isEmpty => _trips.isEmpty;

  Future<Result<void>> _load() async {
    await _reloadFromLocal();
    unawaited(_refresh());
    return const Ok(null);
  }

  Future<void> _reloadFromLocal() async {
    final result = await _tripInteractor.getLocalTrips();
    if (isDisposed) {
      return;
    }
    switch (result) {
      case Ok<List<Trip>>():
        _trips = result.value;
        _source = _source == TripsDataSource.remote
            ? TripsDataSource.remote
            : TripsDataSource.local;
        await _loadLastSyncedAt();
        if (isDisposed) {
          return;
        }
      case Error<List<Trip>>():
        _syncError = result.error;
        _log.warning('Failed to reload local trips', result.error);
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

    final result = await _tripInteractor.syncTrips();
    if (isDisposed) {
      return const Ok(null);
    }
    _syncing = false;

    switch (result) {
      case Ok<List<Trip>>():
        _trips = result.value;
        _source = TripsDataSource.remote;
        await _loadLastSyncedAt();
        if (isDisposed) {
          return const Ok(null);
        }
      case Error<List<Trip>>():
        _syncError = result.error;
        _log.warning('Keeping cached trips after sync failure', result.error);
    }

    notifyListeners();
    return switch (result) {
      Ok<List<Trip>>() => const Ok(null),
      Error<List<Trip>>() => Error(result.error, result.stackTrace),
    };
  }

  Future<void> _loadLastSyncedAt() async {
    final result = await _tripInteractor.getLastSyncedAt();
    if (isDisposed) {
      return;
    }
    switch (result) {
      case Ok<DateTime?>():
        _lastSyncedAt = result.value;
      case Error<DateTime?>():
        _log.warning('Failed to load trip sync time', result.error);
    }
  }

  @override
  void dispose() {
    load.dispose();
    refresh.dispose();
    super.dispose();
  }
}
