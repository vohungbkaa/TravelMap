import 'package:flutter/foundation.dart';

abstract class BaseViewModel {
  Future<void> loadData();

  @mustCallSuper
  void dispose() {}
}
