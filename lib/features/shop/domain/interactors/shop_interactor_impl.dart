import 'package:travel_map/features/shop/data/repositories/shop_repository.dart';
import 'package:travel_map/features/shop/domain/interactors/shop_interactor.dart';
import 'package:travel_map/features/shop/domain/models/shop_product.dart';
import 'package:travel_map/shared/base/models/paging_param.dart';
import 'package:travel_map/shared/result.dart';

class ShopInteractorImpl implements ShopInteractor {
  ShopInteractorImpl(this._serverRepository);

  final ShopServerRepository _serverRepository;

  @override
  Future<Result<List<ShopProduct>>> getProducts({DefaultPagingParam? param}) {
    return _serverRepository.getProducts(param: param);
  }
}
