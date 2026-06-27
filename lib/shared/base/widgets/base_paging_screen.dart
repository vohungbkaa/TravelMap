import 'package:flutter/material.dart';
import 'package:travel_map/shared/base/models/paging_param.dart';
import 'package:travel_map/shared/base/viewmodels/base_paging_view_model.dart';
import 'package:travel_map/shared/base/widgets/base_list_screen.dart';

abstract class BasePagingScreen<VM extends BasePagingViewModel<T, P>, T, P extends PagingParam> extends BaseListScreen<VM, T, P> {
  const BasePagingScreen({super.key});

  double get loadMoreThreshold => 200.0;

  @override
  Widget buildListView(BuildContext context, VM viewModel, List<T> items) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.axisDirection == AxisDirection.down) {
          final maxScroll = scrollInfo.metrics.maxScrollExtent;
          final currentScroll = scrollInfo.metrics.pixels;
          
          if (maxScroll - currentScroll <= loadMoreThreshold) {
            Future.microtask(() => viewModel.loadMore());
          }
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () => viewModel.loadData(isPullToRefresh: true),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: items.length + 1,
          itemBuilder: (context, index) {
            if (index == items.length) {
              return ValueListenableBuilder<bool>(
                valueListenable: viewModel.isLoadingMore,
                builder: (context, isLoadingMore, _) {
                  if (isLoadingMore) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              );
            }

            return buildItem(context, items[index]);
          },
        ),
      ),
    );
  }
}
