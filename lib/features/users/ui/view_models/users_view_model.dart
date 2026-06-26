import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:travel_map/features/users/domain/interactors/user_interactor.dart';
import 'package:travel_map/features/users/domain/models/user.dart';
import 'package:travel_map/shared/result.dart';

class UsersViewModel {
  UsersViewModel(this._userInteractor, this._log) {
    fetchUsers();
  }

  final UserInteractor _userInteractor;
  final Logger _log;

  // Tương đương MutableLiveData và LiveData trong Kotlin
  final ValueNotifier<List<User>> _users = ValueNotifier([]);
  ValueListenable<List<User>> get users => _users;

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  ValueListenable<bool> get isLoading => _isLoading;

  Future<void> fetchUsers() async {
    _isLoading.value = true;
    
    final result = await _userInteractor.getListUser();
    
    if (result is Ok<List<User>>) {
      _users.value = result.value;
    } else if (result is Error<List<User>>) {
      _log.severe('Lỗi lấy danh sách user', result.error);
    }
    
    _isLoading.value = false;
  }
}
