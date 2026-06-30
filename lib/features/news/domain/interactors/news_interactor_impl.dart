import 'package:travel_map/features/news/data/repositories/news_repository.dart';
import 'package:travel_map/features/news/domain/interactors/news_interactor.dart';
import 'package:travel_map/features/news/domain/models/news_post.dart';
import 'package:travel_map/shared/base/models/paging_param.dart';
import 'package:travel_map/shared/result.dart';

class NewsInteractorImpl implements NewsInteractor {
  NewsInteractorImpl(this._serverRepository);

  final NewsServerRepository _serverRepository;

  @override
  Future<Result<List<NewsPost>>> getNewsPosts({DefaultPagingParam? param}) {
    return _serverRepository.getNewsPosts(param: param);
  }
}
