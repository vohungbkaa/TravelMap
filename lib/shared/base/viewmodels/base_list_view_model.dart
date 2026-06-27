import 'package:travel_map/shared/base/viewmodels/base_api_view_model.dart';
import 'package:travel_map/shared/result.dart';

abstract class BaseListViewModel<T, P> extends BaseApiViewModel<List<T>, P> {
  // Alias để lấy nhanh danh sách items hiện tại
  List<T> get items => response.value ?? [];

  @override
  Future<Result<List<T>>> getData(P? param) {
    return getListData(param);
  }

  // Class con hoặc BasePagingViewModel sẽ thực thi hàm này
  Future<Result<List<T>>> getListData(P? param);
}
