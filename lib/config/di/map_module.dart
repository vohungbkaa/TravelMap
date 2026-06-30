import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:travel_map/features/map/data/repositories/map_repository.dart';
import 'package:travel_map/features/map/data/repositories/map_repository_server.dart';
import 'package:travel_map/features/map/domain/interactors/map_interactor.dart';
import 'package:travel_map/features/map/domain/interactors/map_interactor_impl.dart';
import 'package:travel_map/features/map/ui/view_models/map_view_model.dart';

List<SingleChildWidget> get mapModule {
  return [
    Provider<MapServerRepository>(
      create: (context) => MapServerRepositoryImpl(Logger('Map')),
    ),
    Provider<MapInteractor>(
      create: (context) => MapInteractorImpl(context.read()),
    ),
    ChangeNotifierProvider(
      create: (context) => MapViewModel(context.read()),
    ),
  ];
}
