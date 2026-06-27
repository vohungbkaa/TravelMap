import 'package:flutter/material.dart';
import 'package:travel_map/shared/base/models/loading_type.dart';
import 'package:travel_map/shared/base/viewmodels/base_list_view_model.dart';
import 'package:travel_map/shared/base/widgets/base_api_screen.dart';

abstract class BaseListScreen<VM extends BaseListViewModel<T, P>, T, P> extends BaseApiScreen<VM, List<T>, P> {
  const BaseListScreen({super.key});

  int get shimmerItemCount => 5;

  // Giao diện Shimmer cho 1 item (class con có thể override để vẽ bộ xương đẹp hơn)
  Widget buildShimmerItem(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(backgroundColor: Colors.black12),
      title: Container(height: 16, color: Colors.black12),
      subtitle: Container(height: 14, color: Colors.black12, margin: const EdgeInsets.only(top: 8, right: 40)),
    );
  }

  // Giao diện Shimmer cho toàn danh sách
  Widget buildShimmer(BuildContext context) {
    return ListView.builder(
      itemCount: shimmerItemCount,
      itemBuilder: (context, index) => buildShimmerItem(context),
    );
  }

  @override
  Widget buildInitialLoading(BuildContext context, VM viewModel) {
    if (loadingType == LoadingType.shimmer) {
      return buildShimmer(context);
    }
    return super.buildInitialLoading(context, viewModel);
  }

  // UI vẽ cho 1 Item cụ thể
  Widget buildItem(BuildContext context, T item);

  // Tạo ListView (hỗ trợ phân trang ghi đè lại)
  Widget buildListView(BuildContext context, VM viewModel, List<T> items) {
    return RefreshIndicator(
      onRefresh: () => viewModel.loadData(isPullToRefresh: true),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return buildItem(context, items[index]);
        },
      ),
    );
  }

  @override
  Widget buildApiBody(BuildContext context, VM viewModel) {
    return ValueListenableBuilder<List<T>?>(
      valueListenable: viewModel.response,
      builder: (context, items, _) {
        return buildListView(context, viewModel, items ?? []);
      },
    );
  }
}
