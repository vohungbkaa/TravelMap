/// Nơi tập trung toàn bộ chuỗi giao diện và thông báo lỗi của ứng dụng.
/// Thiết kế sẵn sàng cho việc mở rộng đa ngôn ngữ (Localization / i18n).
class AppStrings {
  const AppStrings._();

  // Common / Base
  static const String noData = 'Không có dữ liệu';
  static const String retry = 'Thử lại';
  static const String refresh = 'Làm mới';
  static const String errorOccurred = 'Đã có lỗi xảy ra';

  // Titles & Navigation Tooltips
  static const String githubUsersTitle = 'GitHub Users';
  static const String tripsTitle = 'Trips';
  static const String usersTooltip = 'Users';
  static const String refreshTooltip = 'Refresh';
  static const String tripsTooltip = 'Trips';

  // Trips Feature
  static const String noTripData = 'Không có dữ liệu chuyến đi';
  static const String tripStatusDone = 'Done';
  static const String tripStatusPlanned = 'Planned';
  static String tripOwner(int ownerId) => 'Owner user #$ownerId';

  // Users Feature
  static String userDetails({
    required String email,
    required String phone,
    required String city,
  }) => '$email\nType: $phone • City: $city';
}
