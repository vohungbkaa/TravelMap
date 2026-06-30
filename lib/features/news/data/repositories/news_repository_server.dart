import 'package:logging/logging.dart';
import 'package:travel_map/features/news/data/repositories/news_repository.dart';
import 'package:travel_map/features/news/domain/models/news_post.dart';
import 'package:travel_map/shared/base/models/paging_param.dart';
import 'package:travel_map/shared/result.dart';

class NewsServerRepositoryImpl implements NewsServerRepository {
  NewsServerRepositoryImpl(this._log);

  final Logger _log;

  @override
  Future<Result<List<NewsPost>>> getNewsPosts({
    DefaultPagingParam? param,
  }) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 600));

      const mockPosts = [
        NewsPost(
          id: '1',
          authorName: 'UBND Xã Tiến Thắng',
          authorAvatar:
              'https://images.unsplash.com/photo-1544717305-2782549b5136?w=150',
          timeAgo: '2 giờ trước',
          content:
              '🌾 Lễ hội mừng mùa lúa mới 2026 chính thức diễn ra tại Sân đình '
              'làng Tiến Thắng. Kính mời toàn thể bà con và du khách tới tham '
              'dự các trò chơi dân gian và thưởng thức đặc sản lúa nếp!',
          imageUrls: [
            'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800',
          ],
          likesCount: 128,
          commentsCount: 34,
          category: 'Tin thông báo',
        ),
        NewsPost(
          id: '2',
          authorName: 'HTX Nông Sản Tiến Thắng',
          authorAvatar:
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
          timeAgo: '5 giờ trước',
          content:
              '🍯 Mùa thu hoạch mật ong hoa nhãn đợt 1 năm nay đã hoàn tất. '
              'Mật ong nguyên chất, thơm lừng béo ngậy! Bà con có thể đặt mua '
              'trực tiếp tại gian hàng OCOP trên ứng dụng.',
          imageUrls: [
            'https://images.unsplash.com/photo-1587049352847-4a222e784d38?w=800',
          ],
          likesCount: 95,
          commentsCount: 18,
          category: 'Nông sản OCOP',
        ),
        NewsPost(
          id: '3',
          authorName: 'CLB Du Lịch Trải Nghiệm',
          authorAvatar:
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
          timeAgo: '1 ngày trước',
          content:
              '📸 Điểm check-in Hồ sen Đầm Sậy đang vào mùa nở rộ đẹp nhất '
              'trong năm. Rất thích hợp cho các buổi chụp ảnh áo dài và dã '
              'ngoại cuối tuần cùng gia đình.',
          imageUrls: [
            'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800',
          ],
          likesCount: 210,
          commentsCount: 45,
          category: 'Du lịch & Điểm đến',
        ),
      ];

      return const Ok(mockPosts);
    } on Object catch (error, stackTrace) {
      _log.warning('Failed to load news posts', error, stackTrace);
      return Error(error, stackTrace);
    }
  }
}
