import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:travel_map/features/news/data/repositories/news_repository.dart';
import 'package:travel_map/features/news/data/repositories/news_repository_server.dart';
import 'package:travel_map/features/news/domain/interactors/news_interactor.dart';
import 'package:travel_map/features/news/domain/interactors/news_interactor_impl.dart';
import 'package:travel_map/features/news/ui/view_models/news_view_model.dart';

List<SingleChildWidget> get newsModule {
  return [
    Provider<NewsServerRepository>(
      create: (context) => NewsServerRepositoryImpl(Logger('News')),
    ),
    Provider<NewsInteractor>(
      create: (context) => NewsInteractorImpl(context.read()),
    ),
    Provider(
      create: (context) => NewsViewModel(context.read()),
      dispose: (context, vm) => vm.dispose(),
    ),
  ];
}
