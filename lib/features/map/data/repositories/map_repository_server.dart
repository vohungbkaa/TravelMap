import 'package:logging/logging.dart';
import 'package:travel_map/features/map/data/repositories/map_repository.dart';
import 'package:travel_map/features/map/domain/models/map_place.dart';
import 'package:travel_map/shared/result.dart';

class MapServerRepositoryImpl implements MapServerRepository {
  MapServerRepositoryImpl(this._log);

  final Logger _log;

  @override
  Future<Result<List<MapPlace>>> getPlaces() async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 300));

      const sampleVideoUrl =
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

      const mockPlaces = [
        MapPlace(
          id: 'm1',
          title: 'Đình Làng Tiến Thắng',
          category: 'ditich',
          address: 'Di tích cấp tỉnh · Thế kỷ XVIII',
          distance: '2.1km',
          distanceKm: 2.1,
          imageUrl:
              'https://images.unsplash.com/photo-1544717305-2782549b5136?w=500',
          latitude: 21.0285,
          longitude: 105.8542,
          description:
              'Là một trong những di tích lịch sử tiêu biểu của xã Tiến '
              'Thắng, gắn liền với đời sống văn hoá và tâm linh của bà '
              'con địa phương qua nhiều thế hệ.Là một trong những di tích lịch sử tiêu biểu của xã Tiến '
                  'Thắng, gắn liền với đời sống văn hoá và tâm linh của bà '
                  'con địa phương qua nhiều thế hệ.Là một trong những di tích lịch sử tiêu biểu của xã Tiến '
                  'Thắng, gắn liền với đời sống văn hoá và tâm linh của bà '
                  'con địa phương qua nhiều thế hệ.Là một trong những di tích lịch sử tiêu biểu của xã Tiến '
                  'Thắng, gắn liền với đời sống văn hoá và tâm linh của bà '
                  'con địa phương qua nhiều thế hệ.Là một trong những di tích lịch sử tiêu biểu của xã Tiến '
                  'Thắng, gắn liền với đời sống văn hoá và tâm linh của bà '
                  'con địa phương qua nhiều thế hệ.Là một trong những di tích lịch sử tiêu biểu của xã Tiến '
                  'Thắng, gắn liền với đời sống văn hoá và tâm linh của bà '
                  'con địa phương qua nhiều thế hệ.Là một trong những di tích lịch sử tiêu biểu của xã Tiến '
                  'Thắng, gắn liền với đời sống văn hoá và tâm linh của bà '
                  'con địa phương qua nhiều thế hệ.',
          mediaUrls: [
            'https://images.unsplash.com/photo-1544717305-2782549b5136?w=500',
            'https://images.unsplash.com/photo-1590523741831-ab7e8b8f9c7f?w=500',
            'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=500',
          ],
          mediaItems: [
            MapMediaItem(
              url:
                  'https://images.unsplash.com/photo-1544717305-2782549b5136?w=500',
            ),
            MapMediaItem(
              url:
                  'https://images.unsplash.com/photo-1590523741831-ab7e8b8f9c7f?w=500',
              isVideo: true,
              videoUrl: sampleVideoUrl,
            ),
            MapMediaItem(
              url:
                  'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=500',
            ),
          ],
          views: '12.4k',
          rating: 4.8,
          reviewCount: 96,
          openHours: '7:00 – 17:30',
        ),
        MapPlace(
          id: 'm2',
          title: 'Hồ Sen Đầm Sậy',
          category: 'dulich',
          address: 'Điểm check-in du lịch mùa hè',
          distance: '1.4km',
          distanceKm: 1.4,
          imageUrl:
              'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=500',
          latitude: 21.0330,
          longitude: 105.8480,
          description:
              'Khu cảnh quan sinh thái tuyệt đẹp với hàng ngàn đóa sen '
              'hồng nở rộ mỗi mùa hè. Nơi đây là điểm đến lý tưởng cho '
              'du khách yêu thích chụp ảnh check-in và tận hưởng thiên nhiên.',
          mediaUrls: [
            'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=500',
            'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=500',
          ],
          mediaItems: [
            MapMediaItem(
              url:
                  'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=500',
              isVideo: true,
              videoUrl: sampleVideoUrl,
            ),
            MapMediaItem(
              url:
                  'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=500',
            ),
          ],
          views: '18.9k',
          rating: 4.9,
          reviewCount: 142,
          openHours: '6:00 – 18:00',
        ),
        MapPlace(
          id: 'm3',
          title: 'Vườn Nhãn HTX',
          category: 'dacsan',
          address: 'Vùng nguyên liệu nhãn lồng',
          distance: '0.9km',
          distanceKm: 0.9,
          imageUrl:
              'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=500',
          latitude: 21.0220,
          longitude: 105.8600,
          description:
              'Vùng canh tác nhãn đặc sản ngọt thơm được trồng và chăm sóc '
              'theo quy trình VietGAP bởi Hợp tác xã Tiến Thắng. Du khách '
              'có thể tự tay hái trái chín làm quà.',
          mediaUrls: [
            'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=500',
          ],
          mediaItems: [
            MapMediaItem(
              url:
                  'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=500',
            ),
          ],
          views: '8.6k',
          rating: 4.7,
          reviewCount: 78,
          openHours: '7:30 – 17:00',
        ),
        MapPlace(
          id: 'm4',
          title: 'Chùa Đoài Tiến Thắng',
          category: 'ditich',
          address: 'Kiến trúc Phật giáo cổ Bắc Bộ',
          distance: '3.2km',
          distanceKm: 3.2,
          imageUrl:
              'https://images.unsplash.com/photo-1590523741831-ab7e8b8f9c7f?w=500',
          latitude: 21.0360,
          longitude: 105.8590,
          description:
              'Ngôi chùa cổ kính nằm ẩn mình dưới bóng cây cổ thụ tĩnh mịch. '
              'Nơi đây lưu giữ nhiều tượng Phật cùng đại hồng chung giá trị, '
              'là chốn thanh tịnh cho du khách bái Phật.',
          mediaUrls: [
            'https://images.unsplash.com/photo-1590523741831-ab7e8b8f9c7f?w=500',
          ],
          mediaItems: [
            MapMediaItem(
              url:
                  'https://images.unsplash.com/photo-1590523741831-ab7e8b8f9c7f?w=500',
              isVideo: true,
              videoUrl: sampleVideoUrl,
            ),
          ],
          views: '15.2k',
          rating: 4.8,
          reviewCount: 110,
          openHours: '6:30 – 18:00',
        ),
      ];

      return const Ok(mockPlaces);
    } on Object catch (error, stackTrace) {
      _log.warning('Failed to load map places', error, stackTrace);
      return Error(error, stackTrace);
    }
  }
}
