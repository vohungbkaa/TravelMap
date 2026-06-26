import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:travel_map/features/trips/domain/interactors/trip_interactor.dart';
import 'package:travel_map/features/trips/domain/models/trip.dart';
import 'package:travel_map/shared/result.dart';

class TripsViewModel {
  TripsViewModel(this._tripInteractor, this._log) {
    unawaited(fetchTrips());
  }

  final TripInteractor _tripInteractor;
  final Logger _log;

  final ValueNotifier<List<Trip>> _trips = ValueNotifier([]);
  ValueListenable<List<Trip>> get trips => _trips;

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  ValueListenable<bool> get isLoading => _isLoading;

  Future<void> fetchTrips() async {
    // 1. Hiển thị cache ngay lập tức
    final cached = await _tripInteractor.getLocalTrips();
    if (cached is Ok<List<Trip>>) {
      _trips.value = cached.value;
    }
    
    // Nếu cache trống thì mới xoay loading
    if (_trips.value.isEmpty) {
      _isLoading.value = true;
    }
    
    // 2. Lấy từ API ngầm, lưu xuống DB và cập nhật UI
    final synced = await _tripInteractor.syncTrips();
    
    if (synced is Ok<List<Trip>>) {
      _trips.value = synced.value;
    } else if (synced is Error<List<Trip>>) {
      _log.severe('Lỗi đồng bộ danh sách chuyến đi', synced.error);
    }
    
    _isLoading.value = false;
  }
}
