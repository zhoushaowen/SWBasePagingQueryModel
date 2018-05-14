//
//  UIScrollView+SWBasePagingQuery.m
//  SWBasePagingQueryModel
//
//  Created by zhoushaowen on 2018/5/9.
//  Copyright © 2018年 zhoushaowen. All rights reserved.
//

#import "UIScrollView+SWBasePagingQuery.h"
#import "SWBasePagingQueryModel.h"
#import <MJRefresh.h>
#import <NSObject+RACKVOWrapper.h>
#import <RACEXTScope.h>
#import <RACDisposable.h>
#import <objc/runtime.h>

static void *key_pagingQueryModel = &key_pagingQueryModel;
static void *key_fetchListCompletedBlock = &key_fetchListCompletedBlock;
static void *key_racDisposables = &key_racDisposables;

@interface UIScrollView ()

@property (nonatomic,strong) SWBasePagingQueryModel *pagingQueryModel;
@property (nonatomic,strong) SWFetchListCompletedBlock fetchListCompletedBlock;
@property (nonatomic,strong) NSMutableArray<RACDisposable *> *racDisposables;

@end

@implementation UIScrollView (SWBasePagingQuery)

- (void)setCustomPagingQueryWithMjHeader:(MJRefreshNormalHeader *)mjHeader mjFooter:(MJRefreshAutoNormalFooter *)mjFooter pagingQueryModel:(SWBasePagingQueryModel *)pagingQueryModel completion:(SWFetchListCompletedBlock)fetchListCompletedBlock {
    self.pagingQueryModel = pagingQueryModel;
    self.fetchListCompletedBlock = fetchListCompletedBlock;
    @weakify(self)
    mjHeader.refreshingBlock = ^{
        @strongify(self)
        [self.pagingQueryModel fetchBeginning];
    };
    self.mj_header = mjHeader;
    mjFooter.refreshingBlock = ^{
        @strongify(self)
        [self.pagingQueryModel fetchMore];
    };
    self.mj_footer = mjFooter;
    [self.racDisposables enumerateObjectsUsingBlock:^(RACDisposable * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj dispose];
    }];
    [self.racDisposables removeAllObjects];
    [self.racDisposables addObject:[self.pagingQueryModel rac_observeKeyPath:@"hasMore" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        @strongify(self)
        self.mj_footer.hidden = !self.pagingQueryModel.hasMore;
    }]];
    [self.racDisposables addObject:[self.pagingQueryModel rac_observeKeyPath:@"isFetchingMore" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        @strongify(self)
        self.mj_header.hidden = self.pagingQueryModel.isFetchingMore;
    }]];
    [self.racDisposables addObject:[self.pagingQueryModel rac_observeKeyPath:@"fetchedData" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        @strongify(self)
        if(self.mj_header.isRefreshing){
            [self.mj_header endRefreshing];
        }
        if(!self.pagingQueryModel.hasMore){
            self.mj_footer.hidden = NO;
            [self.mj_footer endRefreshingWithNoMoreData];
        }else{
            if(self.mj_footer.isRefreshing){
                [self.mj_footer endRefreshing];
            }
        }
        if([self isKindOfClass:[UITableView class]]){
            [(UITableView *)self reloadData];
        }else if ([self isKindOfClass:[UICollectionView class]]){
            [(UICollectionView *)self reloadData];
        }
    }]];
    [self.racDisposables addObject:[self.pagingQueryModel rac_observeKeyPath:@"fetchError" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        @strongify(self)
        if(self.fetchListCompletedBlock){
            self.fetchListCompletedBlock(self.pagingQueryModel.fetchError);
        }
    }]];
}

- (void)setDefaultPagingQueryWithModel:(SWBasePagingQueryModel *)pagingQueryModel completion:(SWFetchListCompletedBlock)fetchListCompletedBlock {
    [self setCustomPagingQueryWithMjHeader:[MJRefreshNormalHeader new] mjFooter:[MJRefreshAutoNormalFooter new] pagingQueryModel:pagingQueryModel completion:fetchListCompletedBlock];
}

- (void)setPagingQueryModel:(SWBasePagingQueryModel *)pagingQueryModel {
    objc_setAssociatedObject(self, key_pagingQueryModel, pagingQueryModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SWBasePagingQueryModel *)pagingQueryModel {
    return objc_getAssociatedObject(self, key_pagingQueryModel);
}

- (void)setFetchListCompletedBlock:(SWFetchListCompletedBlock)fetchListCompletedBlock {
    objc_setAssociatedObject(self, key_fetchListCompletedBlock, fetchListCompletedBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SWFetchListCompletedBlock)fetchListCompletedBlock {
    return objc_getAssociatedObject(self, key_fetchListCompletedBlock);
}

- (void)setRacDisposables:(NSMutableArray<RACDisposable *> *)racDisposables {
    objc_setAssociatedObject(self, key_racDisposables, racDisposables, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray<RACDisposable *> *)racDisposables {
    NSMutableArray *disposables = objc_getAssociatedObject(self, key_racDisposables);
    if(!disposables){
        disposables = [NSMutableArray arrayWithCapacity:0];
        self.racDisposables = disposables;
    }
    return disposables;
}








@end
