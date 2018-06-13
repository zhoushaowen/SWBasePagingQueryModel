//
//  TableViewController.m
//  SWBasePagingQueryModel
//
//  Created by zhoushaowen on 2018/5/9.
//  Copyright © 2018年 zhoushaowen. All rights reserved.
//

#import "TableViewController.h"
#import "MyPagingQueryModel.h"
#import <MJRefresh.h>
#import <RACEXTScope.h>
#import <NSObject+RACKVOWrapper.h>
#import <UIView+HUD.h>
#import "UIScrollView+SWBasePagingQuery.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    @weakify(self)
    [self.tableView sw_setDefaultPagingQueryWithModel:[MyPagingQueryModel new] completion:^(NSError *error) {
        @strongify(self)
        if(self.tableView.sw_pagingQueryModel.fetchError){
            [self.view showHUDWithDetailMessage:self.tableView.sw_pagingQueryModel.fetchError.localizedDescription hideWithDelay:1.0f];
        }
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView.sw_pagingQueryModel.fetchedData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = tableView.sw_pagingQueryModel.fetchedData[indexPath.row];
    
    return cell;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}


@end
