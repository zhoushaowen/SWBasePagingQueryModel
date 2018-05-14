# SWBasePagingQueryModel
a paging query kit

### pod 'SWBasePagingQueryModel'

我们开发的时候经常遇到有的页面需要进行分页查询请求,在做下拉刷新和上拉加载更多的时候,每次都会写一一堆重复代码.现在有了这个工具,你们可以实现一句代码搞定tableView和collectionview的下拉刷新和上拉加载更多.
```
[self.tableView setDefaultPagingQueryWithModel:[MyPagingQueryModel new] completion:^(NSError *error) {
        @strongify(self)
        if(self.tableView.pagingQueryModel.fetchError){
            [self.view showHUDWithDetailMessage:self.tableView.pagingQueryModel.fetchError.localizedDescription hideWithDelay:1.0f];
        }
    }];
```

![截图](https://github.com/zhoushaowen/SWBasePagingQueryModel/blob/master/screenshot/1.gif?raw=true)

如果你想使用默认样式的MJRefresh,那么调用下面的方法就行了
```
- (void)setDefaultPagingQueryWithModel:(SWBasePagingQueryModel *)pagingQueryModel completion:(SWFetchListCompletedBlock)fetchListCompletedBlock;
```

如果你想使用自定义样式的MJRefresh,那么调用下面的方法就行了
```
- (void)setCustomPagingQueryWithMjHeader:(MJRefreshNormalHeader *)mjHeader mjfooter:(MJRefreshAutoNormalFooter *)mjFooter pagingQueryModel:(SWBasePagingQueryModel *)pagingQueryModel completion:(SWFetchListCompletedBlock)fetchListCompletedBlock;
```

自定义一个类集成自SWBasePagingQueryModel就可以了,然后在自定义类里面实现下面的方法就可以了
```
/**
 每页数据的数量,你需要重写此方法
 */
- (NSUInteger)pageSize;

```
```
/**
 网络异步请求,你需要重写此方法

 @param pageIndex 刷新的索引,从0开始
 @param completedBlock 异步请求完成的block,在网络请求结束之后必须要调用此block;
 error:网络请求之后返回的错误
 totalCount:分页数据的总个数,如果不知道可以传0
 result:请求到的当前页的数据
 */
- (void)asyncFetchWithPageIndex:(NSInteger)pageIndex completion:(void(^)(NSError *error, NSInteger totalCount, NSArray *result))completedBlock;

```
