import 'package:travel_map/features/shop/domain/models/shop_product.dart';
import 'package:travel_map/shared/base/models/paging_param.dart';
import 'package:travel_map/shared/result.dart';

abstract interface class ShopServerRepository {
  Future<Result<List<ShopProduct>>> getProducts({DefaultPagingParam? param});
}
