import 'package:travel_map/features/shop/domain/interactors/shop_interactor.dart';
import 'package:travel_map/features/shop/domain/models/shop_product.dart';
import 'package:travel_map/shared/base/models/paging_param.dart';
import 'package:travel_map/shared/base/viewmodels/base_paging_view_model.dart';
import 'package:travel_map/shared/result.dart';

class ShopViewModel
    extends BasePagingViewModel<ShopProduct, DefaultPagingParam> {
  ShopViewModel(this._shopInteractor);

  final ShopInteractor _shopInteractor;

  @override
  Future<Result<List<ShopProduct>>> getListPagingData(
    DefaultPagingParam? param,
  ) async {
    return _shopInteractor.getProducts(param: param);
  }
}
