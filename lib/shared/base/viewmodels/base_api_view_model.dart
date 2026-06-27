import 'package:flutter/foundation.dart';
import 'package:travel_map/shared/base/viewmodels/base_view_model.dart';
import 'package:travel_map/shared/result.dart';

abstract class BaseApiViewModel<R, P> extends BaseViewModel {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<bool> isEmpty = ValueNotifier(true);
  final ValueNotifier<String?> error = ValueNotifier(null);
  final ValueNotifier<R?> response = ValueNotifier(null);

  P? paramRequest;

  // Hàm chuẩn để gọi tải dữ liệu (có xử lý trạng thái)
  Future<void> loadData({P? param, bool isPullToRefresh = false}) async {
    paramRequest = param ?? paramRequest;
    
    if (!isPullToRefresh) {
      isLoading.value = true;
    }
    
    error.value = null;

    final result = await getData(paramRequest);

    if (result is Ok<R>) {
      response.value = await mappingResponse(result.value);
      isEmpty.value = checkIsEmpty(response.value);
    } else if (result is Error<R>) {
      error.value = result.error.toString();
    }

    isLoading.value = false;
  }

  // Class con bắt buộc implement để gọi API/DB thực tế
  Future<Result<R>> getData(P? param);

  // Hook hỗ trợ map dữ liệu/chuyển đổi dữ liệu trước khi gán
  Future<R> mappingResponse(R rawResponse) async {
    return rawResponse;
  }

  // Kiểm tra rỗng mặc định
  bool checkIsEmpty(R? value) {
    if (value == null) return true;
    if (value is Iterable) return value.isEmpty;
    return false;
  }

  @override
  @mustCallSuper
  void dispose() {
    isLoading.dispose();
    isEmpty.dispose();
    error.dispose();
    response.dispose();
    super.dispose();
  }
}
