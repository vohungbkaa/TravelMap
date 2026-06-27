import 'package:travel_map/shared/base/viewmodels/base_api_view_model.dart';

abstract class BaseListViewModel<T, P> extends BaseApiViewModel<List<T>, P> {
  // Alias để lấy nhanh danh sách items hiện tại
  List<T> get items => response.value ?? [];
}
