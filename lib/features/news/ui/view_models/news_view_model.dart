import 'package:travel_map/features/news/domain/interactors/news_interactor.dart';
import 'package:travel_map/features/news/domain/models/news_post.dart';
import 'package:travel_map/shared/base/models/paging_param.dart';
import 'package:travel_map/shared/base/viewmodels/base_paging_view_model.dart';
import 'package:travel_map/shared/result.dart';

class NewsViewModel
    extends BasePagingViewModel<NewsPost, DefaultPagingParam> {
  NewsViewModel(this._newsInteractor);

  final NewsInteractor _newsInteractor;

  @override
  Future<Result<List<NewsPost>>> getListPagingData(
    DefaultPagingParam? param,
  ) async {
    return _newsInteractor.getNewsPosts(param: param);
  }
}
