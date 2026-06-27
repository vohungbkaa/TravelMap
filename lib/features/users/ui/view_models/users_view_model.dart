import 'package:logging/logging.dart';
import 'package:travel_map/features/users/domain/interactors/user_interactor.dart';
import 'package:travel_map/features/users/domain/models/user.dart';
import 'package:travel_map/shared/base/models/paging_param.dart';
import 'package:travel_map/shared/base/viewmodels/base_paging_view_model.dart';
import 'package:travel_map/shared/result.dart';

class UsersViewModel extends BasePagingViewModel<User, DefaultPagingParam> {
  UsersViewModel(this._userInteractor, this._log);

  final UserInteractor _userInteractor;
  final Logger _log;

  int get lastId => pageIndex == 1 ? 0 : (items.lastOrNull?.id ?? 0);

  @override
  Future<Result<List<User>>> getListPagingData(DefaultPagingParam? param) {
    _log.info('Fetching users page $pageIndex');
    return _userInteractor.syncUsers(since: lastId, perPage: pageSize);
  }
}
