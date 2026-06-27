import 'package:flutter/material.dart';
import 'package:travel_map/shared/base/viewmodels/base_view_model.dart';

abstract class BaseScreen<VM extends BaseViewModel> extends StatelessWidget {
  const BaseScreen({super.key});

  // 1. Cung cấp ViewModel
  VM getViewModel(BuildContext context);

  // 2. Vẽ UI body chính của màn hình
  Widget buildBody(BuildContext context, VM viewModel);

  // 3. Tùy chọn AppBar
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget build(BuildContext context) {
    final viewModel = getViewModel(context);

    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(context, viewModel),
    );
  }
}
