abstract class PagingParam {
  int pageIndex;
  int pageSize;

  PagingParam({this.pageIndex = 1, this.pageSize = 20});
}

class DefaultPagingParam extends PagingParam {
  DefaultPagingParam({super.pageIndex = 1, super.pageSize = 20});
}
