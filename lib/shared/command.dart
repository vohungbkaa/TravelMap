import 'package:travel_map/shared/result.dart';
import 'package:travel_map/shared/safe_change_notifier.dart';

class Command0<T> extends SafeChangeNotifier {
  Command0(this._action);

  final Future<Result<T>> Function() _action;

  bool _running = false;
  bool get running => _running;

  Result<T>? _result;
  Result<T>? get result => _result;

  Future<void> execute() async {
    if (_running) {
      return;
    }

    _running = true;
    _result = null;
    notifyListeners();

    _result = await _action();
    if (isDisposed) {
      return;
    }

    _running = false;
    notifyListeners();
  }
}
