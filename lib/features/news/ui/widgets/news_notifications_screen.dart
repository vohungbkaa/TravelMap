import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:travel_map/shared/theme/app_colors.dart';
import 'package:travel_map/shared/theme/app_typography.dart';

enum NotiKind { like, comment, post, approve, event }

class NotificationItem {
  NotificationItem({
    required this.kind,
    required this.who,
    required this.text,
    required this.time,
    this.previewUrl,
    this.unread = false,
  });

  final NotiKind kind;
  final String who;
  final String text;
  final String time;
  final String? previewUrl;
  bool unread;
}

class NewsNotificationsScreen extends StatefulWidget {
  const NewsNotificationsScreen({super.key});

  static const routeName = 'news-notifications';
  static const routePath = '/news-notifications';

  @override
  State<NewsNotificationsScreen> createState() => _NewsNotificationsScreenState();
}

class _NewsNotificationsScreenState extends State<NewsNotificationsScreen> {
  String _activeTab = 'all'; // 'all' or 'unread'

  final List<NotificationItem> _notifications = [
    NotificationItem(
      kind: NotiKind.approve,
      who: 'Quản trị viên',
      text: 'Bài viết “Mùa nhãn quê tôi” của bạn đã được duyệt và đăng lên bảng tin.',
      time: '10 phút',
      unread: true,
    ),
    NotificationItem(
      kind: NotiKind.like,
      who: 'Nguyễn Thị Hoa',
      text: 'đã thả ♥ bài viết của bạn.',
      time: '30 phút',
      previewUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
      unread: true,
    ),
    NotificationItem(
      kind: NotiKind.comment,
      who: 'Trần Văn Bình',
      text: 'đã bình luận: “Đẹp quá bác ơi, bao giờ mở bán?”',
      time: '1 giờ',
      previewUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      unread: true,
    ),
    NotificationItem(
      kind: NotiKind.post,
      who: 'UBND xã Tiến Thắng',
      text: 'vừa đăng bài viết mới: Lễ hội rước kiệu đầu xuân.',
      time: '2 giờ',
      previewUrl: 'https://images.unsplash.com/photo-1533105079780-92b9be482077?w=150',
      unread: false,
    ),
    NotificationItem(
      kind: NotiKind.like,
      who: 'Lê Minh Tuấn và 12 người khác',
      text: 'đã thả 👍 bài viết của bạn.',
      time: '5 giờ',
      previewUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150',
      unread: false,
    ),
    NotificationItem(
      kind: NotiKind.event,
      who: 'Đoàn Thanh niên',
      text: 'mời bạn tham gia sự kiện: Dọn vệ sinh đường làng Chủ nhật này.',
      time: 'Hôm qua',
      unread: false,
    ),
    NotificationItem(
      kind: NotiKind.comment,
      who: 'Phạm Thu Hằng',
      text: 'đã trả lời bình luận của bạn trong bài “Đình làng Tiến Thắng”.',
      time: '2 ngày',
      previewUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      unread: false,
    ),
  ];

  int get _unreadCount => _notifications.where((n) => n.unread).length;

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n.unread = false;
      }
    });
  }

  void _toggleNotificationUnread(NotificationItem item) {
    setState(() {
      item.unread = !item.unread;
    });
  }

  Widget _buildNotiIcon(NotiKind kind) {
    const double size = 36;
    switch (kind) {
      case NotiKind.like:
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: Color(0xFFE57373), // Red/Terracotta like color
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.favorite,
              size: 16,
              color: Colors.white,
            ),
          ),
        );
      case NotiKind.comment:
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: AppColors.accent, // Deep forest green
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              LucideIcons.messageCircle,
              size: 16,
              color: Colors.white,
            ),
          ),
        );
      case NotiKind.post:
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              LucideIcons.newspaper,
              size: 16,
              color: Colors.white,
            ),
          ),
        );
      case NotiKind.approve:
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: Color(0xFF4CAF50), // Green for approval
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              LucideIcons.checkCircle2,
              size: 16,
              color: Colors.white,
            ),
          ),
        );
      case NotiKind.event:
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: AppColors.gold,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              LucideIcons.bell,
              size: 16,
              color: Colors.white,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _activeTab == 'all'
        ? _notifications
        : _notifications.where((n) => n.unread).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header matching Prototype exactly
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.border.withValues(alpha: 0.4),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.chevronLeft,
                        size: 18,
                        color: AppColors.foreground,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thông báo',
                          style: TextStyle(
                            fontSize: AppTypography.s14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.foreground,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$_unreadCount thông báo mới',
                          style: TextStyle(
                            fontSize: AppTypography.s10,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_unreadCount > 0)
                    GestureDetector(
                      onTap: _markAllAsRead,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Đánh dấu đã đọc',
                          style: TextStyle(
                            fontSize: AppTypography.s10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.foreground,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Tabs matching Prototype
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  _buildTabButton('all', 'Tất cả'),
                  const SizedBox(width: 8),
                  _buildTabButton('unread', 'Chưa đọc'),
                ],
              ),
            ),

            // Notification List
            Expanded(
              child: filteredList.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final n = filteredList[index];
                        return GestureDetector(
                          onTap: () => _toggleNotificationUnread(n),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                            decoration: BoxDecoration(
                              color: n.unread
                                  ? AppColors.primary.withValues(alpha: 0.05)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildNotiIcon(n.kind),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: AppTypography.s12,
                                            color: AppColors.foreground,
                                            height: 1.3,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: n.who,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const TextSpan(text: ' '),
                                            TextSpan(text: n.text),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${n.time} trước',
                                        style: TextStyle(
                                          fontSize: AppTypography.s10,
                                          color: AppColors.mutedForeground,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (n.previewUrl != null) ...[
                                  const SizedBox(width: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      n.previewUrl!,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        width: 40,
                                        height: 40,
                                        color: AppColors.secondary,
                                        child: const Icon(
                                          LucideIcons.image,
                                          size: 16,
                                          color: AppColors.mutedForeground,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                if (n.unread) ...[
                                  const SizedBox(width: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 14),
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String tabId, String label) {
    final isSelected = _activeTab == tabId;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = tabId),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.border.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: AppTypography.s10,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.foreground,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.bellOff,
              size: 20,
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Không có thông báo nào',
            style: TextStyle(
              fontSize: AppTypography.s12,
              fontWeight: FontWeight.bold,
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _activeTab == 'unread'
                ? 'Bạn đã đọc tất cả thông báo của mình.'
                : 'Thông tin về lượt thích, bình luận sẽ xuất hiện ở đây.',
            style: TextStyle(
              fontSize: AppTypography.s11,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
