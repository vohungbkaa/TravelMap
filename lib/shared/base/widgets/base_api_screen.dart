import 'package:flutter/material.dart';
import 'package:travel_map/shared/base/models/loading_type.dart';
import 'package:travel_map/shared/base/viewmodels/base_api_view_model.dart';
import 'package:travel_map/shared/base/widgets/base_screen.dart';
import 'package:travel_map/shared/base/widgets/travel_map_loader.dart';

abstract class BaseApiScreen<VM extends BaseApiViewModel<R, P>, R, P> extends BaseScreen<VM> {
  const BaseApiScreen({super.key});

  // Tham số ban đầu để gọi API
  P? getLoadParam(BuildContext context);

  // Cờ tự động load data khi mở màn hình
  bool get autoLoad => true;

  // Loại loading (Mặc định là full screen Process Loading)
  LoadingType get loadingType => LoadingType.process;

  // UI vẽ cho dữ liệu thực tế sau khi lấy thành công
  Widget buildApiBody(BuildContext context, VM viewModel);

  // UI khi dữ liệu rỗng
  Widget buildEmptyState(BuildContext context, VM viewModel) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.info_outline, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Không có dữ liệu'),
          TextButton(
            onPressed: () => viewModel.loadData(),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  // UI loading lần đầu tiên
  Widget buildInitialLoading(BuildContext context, VM viewModel) {
    return const Center(child: CircularProgressIndicator());
  }

  @override
  Widget buildBody(BuildContext context, VM viewModel) {
    final bodyContent = ValueListenableBuilder<bool>(
      valueListenable: viewModel.isLoading,
      builder: (context, isLoading, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: viewModel.isEmpty,
          builder: (context, isEmpty, _) {
            // 1. Loading lần đầu
            if (isLoading && isEmpty) {
              return buildInitialLoading(context, viewModel);
            }

            // 2. Rỗng
            if (isEmpty) {
              return buildEmptyState(context, viewModel);
            }

            // 3. Có data
            return Stack(
              children: [
                buildApiBody(context, viewModel),
                
                // Overlay Process Loading đè lên màn hình khi refresh ngầm
                if (isLoading && loadingType == LoadingType.process)
                  const TravelMapLoader(),
              ],
            );
          },
        );
      },
    );

    if (autoLoad) {
      return InitialLifeCycleTrigger(
        onInit: () {
          final param = getLoadParam(context);
          viewModel.loadData(param: param);
        },
        child: bodyContent,
      );
    }

    return bodyContent;
  }
}

// Widget Stateful nhỏ để bắt sự kiện initState
class InitialLifeCycleTrigger extends StatefulWidget {
  final VoidCallback onInit;
  final Widget child;

  const InitialLifeCycleTrigger({
    super.key,
    required this.onInit,
    required this.child,
  });

  @override
  State<InitialLifeCycleTrigger> createState() => _InitialLifeCycleTriggerState();
}

class _InitialLifeCycleTriggerState extends State<InitialLifeCycleTrigger> {
  @override
  void initState() {
    super.initState();
    widget.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
