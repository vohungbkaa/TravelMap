import 'package:travel_map/features/news/domain/models/news_post.dart';
import 'package:travel_map/shared/base/models/paging_param.dart';
import 'package:travel_map/shared/result.dart';

abstract interface class NewsServerRepository {
  Future<Result<List<NewsPost>>> getNewsPosts({DefaultPagingParam? param});
}
