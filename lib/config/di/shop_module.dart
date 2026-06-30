import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:travel_map/features/shop/data/repositories/shop_repository.dart';
import 'package:travel_map/features/shop/data/repositories/shop_repository_server.dart';
import 'package:travel_map/features/shop/domain/interactors/shop_interactor.dart';
import 'package:travel_map/features/shop/domain/interactors/shop_interactor_impl.dart';
import 'package:travel_map/features/shop/ui/view_models/shop_view_model.dart';

List<SingleChildWidget> get shopModule {
  return [
    Provider<ShopServerRepository>(
      create: (context) => ShopServerRepositoryImpl(Logger('Shop')),
    ),
    Provider<ShopInteractor>(
      create: (context) => ShopInteractorImpl(context.read()),
    ),
    Provider(
      create: (context) => ShopViewModel(context.read()),
      dispose: (context, vm) => vm.dispose(),
    ),
  ];
}
