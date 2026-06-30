import 'package:logging/logging.dart';
import 'package:travel_map/features/shop/data/repositories/shop_repository.dart';
import 'package:travel_map/features/shop/domain/models/shop_product.dart';
import 'package:travel_map/shared/base/models/paging_param.dart';
import 'package:travel_map/shared/result.dart';

class ShopServerRepositoryImpl implements ShopServerRepository {
  ShopServerRepositoryImpl(this._log);

  final Logger _log;

  @override
  Future<Result<List<ShopProduct>>> getProducts({
    DefaultPagingParam? param,
  }) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));

      const mockProducts = [
        ShopProduct(
          id: 'p1',
          name: 'Nhãn Lồng Cổ Tiến Thắng',
          price: '65.000đ / kg',
          origin: 'HTX Nông Sản Tiến Thắng',
          rating: '4.9',
          imageUrl:
              'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=500',
          category: 'Hoa quả tươi',
        ),
        ShopProduct(
          id: 'p2',
          name: 'Mật Ong Hoa Nhãn Nguyên Chất',
          price: '180.000đ / hũ 500ml',
          origin: 'Trại Ong Ông Hùng',
          rating: '5.0',
          imageUrl:
              'https://images.unsplash.com/photo-1587049352847-4a222e784d38?w=500',
          category: 'Đặc sản chế biến',
        ),
        ShopProduct(
          id: 'p3',
          name: 'Gạo Nếp Thơm Hương Thắng',
          price: '32.000đ / kg',
          origin: 'Cánh Đồng Mẫu Lớn',
          rating: '4.8',
          imageUrl:
              'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=500',
          category: 'Nông sản thô',
        ),
        ShopProduct(
          id: 'p4',
          name: 'Trà Đinh Tân Cương Hữu Cơ',
          price: '250.000đ / hộp 200g',
          origin: 'Đồi Trà Tiến Thắng',
          rating: '4.9',
          imageUrl:
              'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=500',
          category: 'Đặc sản chế biến',
        ),
      ];

      return const Ok(mockProducts);
    } on Object catch (error, stackTrace) {
      _log.warning('Failed to load shop products', error, stackTrace);
      return Error(error, stackTrace);
    }
  }
}
