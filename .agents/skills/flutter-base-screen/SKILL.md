---
name: flutter-base-screen
description: Quy chuẩn kế thừa và tích hợp các màn hình Flutter với bộ khung BaseArchitecture (BasePagingScreen, BaseListScreen, BaseApiScreen, BasePagingViewModel) trong dự án TravelSocial.
---

# Hướng Dẫn Kế Thừa Bộ Khung Base Architecture (TravelSocial)

Tài liệu này hướng dẫn cách xây dựng một tính năng/màn hình mới dựa trên thiết kế chuẩn đã triển khai trong mẫu `features/users`.

---

## 1. Cấu Trúc Chuẩn Của Một Feature

Khi thêm một tính năng mới (ví dụ `notifications`), hãy tạo cấu trúc thư mục như sau:

```txt
lib/features/notifications/
├── data/
│   ├── repositories/        # Contract & Implementation cho Local/Server Repositories
│   └── services/            # ApiService (Retrofit) & LocalService (Drift/SQLite)
├── domain/
│   ├── interactors/         # Business Use Cases / Interactors
│   └── models/              # Data models chính của domain
└── ui/
    ├── view_models/         # Class kế thừa BaseViewModel / BasePagingViewModel
    └── widgets/             # Screen kế thừa BaseScreen / BasePagingScreen
```

Đồng thời tạo file DI module tại: `lib/config/di/notifications_module.dart`.

---

## 2. Xây Dựng ViewModel Kế Thừa Base

### Cách 1: Màn Hình Danh Sách Có Phân Trang (Pagination)
Kế thừa `BasePagingViewModel<T, P>` (với `T` là kiểu Model của dòng, `P` là Param kế thừa `PagingParam`).

```dart
import 'package:travel_map/shared/base/models/paging_param.dart';
import 'package:travel_map/shared/base/viewmodels/base_paging_view_model.dart';
import 'package:travel_map/shared/result.dart';

class NotificationsViewModel extends BasePagingViewModel<NotificationModel, DefaultPagingParam> {
  NotificationsViewModel(this._notificationInteractor);

  final NotificationInteractor _notificationInteractor;

  @override
  Future<Result<List<NotificationModel>>> getListPagingData(DefaultPagingParam? param) {
    return _notificationInteractor.getNotifications(
      page: pageIndex,
      pageSize: pageSize,
    );
  }
}
```

### Cách 2: Màn Hình Gọi API Đơn (Single API Response)
Kế thừa `BaseApiViewModel<R, P>` (với `R` là Data Response, `P` là Param Request).

```dart
class ProfileViewModel extends BaseApiViewModel<UserProfile, void> {
  ProfileViewModel(this._userInteractor);
  final UserInteractor _userInteractor;

  @override
  Future<Result<UserProfile>> getData(void param) {
    return _userInteractor.getUserProfile();
  }
}
```

---

## 3. Xây Dựng Screen (UI) Kế Thừa Base

### Màn Hình Phân Trang Kế Thừa `BasePagingScreen`
Tham chiếu mẫu tại [users_screen.dart](file:///Users/danhtung/Documents/TravelSocial/lib/features/users/ui/widgets/users_screen.dart):

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_map/shared/base/models/loading_type.dart';
import 'package:travel_map/shared/base/models/paging_param.dart';
import 'package:travel_map/shared/base/widgets/base_paging_screen.dart';

class NotificationsScreen extends BasePagingScreen<NotificationsViewModel, NotificationModel, DefaultPagingParam> {
  const NotificationsScreen({super.key});

  static const routeName = 'notifications';
  static const routePath = '/notifications';

  // 1. Cung cấp ViewModel từ Provider context
  @override
  NotificationsViewModel getViewModel(BuildContext context) => context.read<NotificationsViewModel>();

  // 2. Tham số khởi tạo dữ liệu ban đầu
  @override
  DefaultPagingParam? getLoadParam(BuildContext context) => DefaultPagingParam(pageSize: 20);

  // 3. (Tùy chọn) Chọn loại loading: LoadingType.shimmer hoặc LoadingType.process
  @override
  LoadingType get loadingType => LoadingType.shimmer;

  // 4. (Tùy chọn) Khai báo AppBar
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(title: const Text('Thông báo'));
  }

  // 5. Vẽ UI cho từng item trong danh sách (Bắt buộc)
  @override
  Widget buildItem(BuildContext context, NotificationModel item) {
    return ListTile(
      title: Text(item.title),
      subtitle: Text(item.body),
    );
  }
}
```

---

## 4. Đăng Ký Dependency Injection (DI)

### Bước 1: Khai báo Module trong `lib/config/di/<feature>_module.dart`
Tham chiếu mẫu tại [users_module.dart](file:///Users/danhtung/Documents/TravelSocial/lib/config/di/users_module.dart):

```dart
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:travel_map/config/feature_env.dart';
import 'package:travel_map/shared/network/api_client_factory.dart';

List<SingleChildWidget> get notificationsModule {
  return [
    Provider(
      create: (context) => NotificationApiService(
        context.read<ApiClientFactory>().create(
          baseUrl: FeatureConfig.user.baseUrl, // Hoặc định nghĩa thêm feature trong FeatureConfig
        ),
      ),
    ),
    Provider<NotificationInteractor>(
      create: (context) => NotificationInteractorImpl(context.read()),
    ),
    ChangeNotifierProvider(
      create: (context) => NotificationsViewModel(context.read()),
    ),
  ];
}
```

### Bước 2: Thêm module vào `lib/config/dependencies.dart`
```dart
List<SingleChildWidget> get providersDevelopment {
  return [
    ...baseModule,
    ...authModule,
    ...usersModule,
    ...tripsModule,
    ...notificationsModule, // <--- Thêm vào đây
  ];
}
```

---

## 5. Đăng Ký Điều Hướng (Routing)

Thêm route trong `lib/routing/router.dart` hoặc các file route tính năng:
```dart
GoRoute(
  path: NotificationsScreen.routePath,
  name: NotificationsScreen.routeName,
  builder: (context, state) => const NotificationsScreen(),
),
```
