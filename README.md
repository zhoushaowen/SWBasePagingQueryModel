# SWBasePagingQueryModel
a paging query kit

### pod 'SWBasePagingQueryModel'

一句代码搞定tableView和collectionview的下拉刷新和上拉加载更多
`    [self.tableView setDefaultPagingQueryWithModel:[MyPagingQueryModel new] completion:^(NSError *error) {
        @strongify(self)
        if(self.tableView.pagingQueryModel.fetchError){
            [self.view showHUDWithDetailMessage:self.tableView.pagingQueryModel.fetchError.localizedDescription hideWithDelay:1.0f];
        }
    }];
`
