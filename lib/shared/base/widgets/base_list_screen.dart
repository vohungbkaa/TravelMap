import 'package:flutter/material.dart';
import 'package:travel_map/shared/base/models/loading_type.dart';
import 'package:travel_map/shared/base/viewmodels/base_list_view_model.dart';
import 'package:travel_map/shared/base/widgets/base_api_screen.dart';
import 'package:travel_map/shared/widgets/shimmer_placeholder.dart';

abstract class BaseListScreen<VM extends BaseListViewModel<T, P>, T, P>
    extends BaseApiScreen<VM, List<T>, P> {
  const BaseListScreen({super.key});

  int get shimmerItemCount => 10;

  // Giao diện Shimmer cho 1 item (class con có thể override nếu muốn custom riêng)
  Widget buildShimmerItem(BuildContext context) {
    return const ListTile(
      leading: ShimmerPlaceholder.circular(radius: 20),
      title: Align(
        alignment: Alignment.centerLeft,
        child: ShimmerPlaceholder(height: 16, width: 120, borderRadius: 4),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerPlaceholder(height: 12, width: 180, borderRadius: 4),
            SizedBox(height: 6),
            ShimmerPlaceholder(height: 12, width: 140, borderRadius: 4),
          ],
        ),
      ),
      isThreeLine: true,
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
