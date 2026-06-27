import 'package:flutter/foundation.dart';
import 'package:travel_map/shared/base/models/paging_param.dart';
import 'package:travel_map/shared/base/viewmodels/base_list_view_model.dart';
import 'package:travel_map/shared/result.dart';

abstract class BasePagingViewModel<T, P extends PagingParam> extends BaseListViewModel<T, P> {
  final ValueNotifier<bool> isLoadingMore = ValueNotifier(false);
  bool hasNext = false;

  @override
  Future<void> loadData({P? param, bool isPullToRefresh = false}) async {
    hasNext = false;
    isLoadingMore.value = false;
    if (param != null) {
      param.pageIndex = 1;
    } else if (paramRequest != null) {
      paramRequest!.pageIndex = 1;
    }
    await super.loadData(param: param, isPullToRefresh: isPullToRefresh);
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasNext) return;

    isLoadingMore.value = true;

    // Tăng pageIndex
    if (paramRequest != null) {
      paramRequest!.pageIndex += 1;
    }

    final result = await getData(paramRequest);

    if (result is Ok<List<T>>) {
      final newItems = await mappingResponse(result.value);
      // Nối tiếp data vào list hiện tại
      response.value = [...(response.value ?? []), ...newItems];
      
      // Tính toán hasNext
      final pageSize = paramRequest?.pageSize ?? 20;
      hasNext = result.value.length >= pageSize;
    } else if (result is Error<List<T>>) {
      error.value = result.error.toString();
      // Rollback trang nếu lỗi
      if (paramRequest != null && paramRequest!.pageIndex > 1) {
        paramRequest!.pageIndex -= 1;
      }
    }

    isLoadingMore.value = false;
  }

  @override
  Future<Result<List<T>>> getData(P? param) {
    return getListPagingData(param);
  }

  // Class con thực thi hàm này để lấy data theo trang
  Future<Result<List<T>>> getListPagingData(P? param);

  @override
  void dispose() {
    isLoadingMore.dispose();
    super.dispose();
  }
}
