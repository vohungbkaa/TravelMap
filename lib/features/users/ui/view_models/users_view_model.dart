import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:travel_map/features/users/domain/interactors/user_interactor.dart';
import 'package:travel_map/features/users/domain/models/user.dart';
import 'package:travel_map/shared/result.dart';

class UsersViewModel {
  UsersViewModel(this._userInteractor, this._log) {
    unawaited(fetchUsers());
  }

  final UserInteractor _userInteractor;
  final Logger _log;

  // Tương đương MutableLiveData và LiveData trong Kotlin
  final ValueNotifier<List<User>> _users = ValueNotifier([]);
  ValueListenable<List<User>> get users => _users;

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  ValueListenable<bool> get isLoading => _isLoading;

  Future<void> fetchUsers() async {
    // 1. Hiển thị cache ngay lập tức
    final cached = await _userInteractor.getLocalUsers();
    if (cached is Ok<List<User>>) {
      _users.value = cached.value;
    }
    
    // Nếu cache trống thì mới xoay loading
    if (_users.value.isEmpty) {
      _isLoading.value = true;
    }
    
    // 2. Lấy từ API ngầm, lưu xuống DB và cập nhật UI
    final synced = await _userInteractor.syncUsers();
    
    if (synced is Ok<List<User>>) {
      _users.value = synced.value;
    } else if (synced is Error<List<User>>) {
      _log.severe('Lỗi đồng bộ danh sách user', synced.error);
    }
    
    _isLoading.value = false;
  }
}
