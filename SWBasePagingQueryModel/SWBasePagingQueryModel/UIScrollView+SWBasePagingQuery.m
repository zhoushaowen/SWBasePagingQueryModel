//
//  UIScrollView+SWBasePagingQuery.m
//  SWBasePagingQueryModel
//
//  Created by zhoushaowen on 2018/5/9.
//  Copyright © 2018年 zhoushaowen. All rights reserved.
//

#import "UIScrollView+SWBasePagingQuery.h"
#import "SWBasePagingQueryModel.h"
#import <MJRefresh/MJRefresh.h>
#import <ReactiveObjC/NSObject+RACKVOWrapper.h>
#import <ReactiveObjC/RACEXTScope.h>
#import <ReactiveObjC/RACDisposable.h>
#import <objc/runtime.h>

static void *key_pagingQueryModel = &key_pagingQueryModel;
static void *key_fetchListCompletedBlock = &key_fetchListCompletedBlock;
static void *key_racDisposables = &key_racDisposables;

@interface UIScrollView ()

@property (nonatomic,strong) SWBasePagingQueryModel *sw_pagingQueryModel;
@property (nonatomic,strong) SWFetchListCompletedBlock sw_fetchListCompletedBlock;
@property (nonatomic,strong) NSMutableArray<RACDisposable *> *sw_racDisposables;

@end

@implementation UIScrollView (SWBasePagingQuery)

- (void)sw_setDefaultPagingQueryWithModel:(SWBasePagingQueryModel *_Nonnull)pagingQueryModel enablePullRefresh:(BOOL)isEnablePullRefresh completion:(SWFetchListCompletedBlock)fetchListCompletedBlock __deprecated_msg("Use sw_setCustomPagingQueryWithMjHeader:mjFooter:pagingQueryModel:completion:") {
    if(isEnablePullRefresh){
        [self sw_setCustomPagingQueryWithMjHeader:[MJRefreshNormalHeader new] mjFooter:[MJRefreshAutoNormalFooter new] pagingQueryModel:pagingQueryModel completion:fetchListCompletedBlock];
    }else{
        [self sw_setCustomPagingQueryWithMjHeader:nil mjFooter:[MJRefreshAutoNormalFooter new] pagingQueryModel:pagingQueryModel completion:fetchListCompletedBlock];
    }
}

- (void)sw_setCustomPagingQueryWithMjHeader:(MJRefreshNormalHeader *_Nullable)mjHeader mjFooter:(MJRefreshAutoNormalFooter *_Nullable)mjFooter pagingQueryModel:(SWBasePagingQueryModel *_Nonnull)pagingQueryModel pullRefreshBlock:(void(^)(void))pullRefreshBlock completion:(SWFetchListCompletedBlock)fetchListCompletedBlock __deprecated_msg("Use sw_setCustomPagingQueryWithMjHeader:mjFooter:pagingQueryModel:willFetchBeginBlock:willFetchMoreBlock:completion:") {
    [self sw_setCustomPagingQueryWithMjHeader:mjHeader mjFooter:mjFooter pagingQueryModel:pagingQueryModel willFetchBeginBlock:pullRefreshBlock willFetchMoreBlock:nil completion:fetchListCompletedBlock];
}

- (void)sw_setCustomPagingQueryWithMjHeader:(MJRefreshNormalHeader *_Nullable)mjHeader mjFooter:(MJRefreshAutoNormalFooter *_Nullable)mjFooter pagingQueryModel:(SWBasePagingQueryModel *_Nonnull)pagingQueryModel willFetchBeginBlock:(void(^)(void))willFetchBeginBlock willFetchMoreBlock:(void(^)(void))willFetchMoreBlock completion:(SWFetchListCompletedBlock)fetchListCompletedBlock {
    self.sw_pagingQueryModel = pagingQueryModel;
    self.sw_fetchListCompletedBlock = fetchListCompletedBlock;
    @weakify(self)
    mjHeader.refreshingBlock = ^{
        @strongify(self)
        if(willFetchBeginBlock){
            willFetchBeginBlock();
        }
        [self.sw_pagingQueryModel fetchBeginning];
    };
    self.mj_header = mjHeader;
    mjFooter.refreshingBlock = ^{
        @strongify(self)
        if(willFetchMoreBlock){
            willFetchMoreBlock();
        }
        [self.sw_pagingQueryModel fetchMore];
    };
    self.mj_footer = mjFooter;
    [self.sw_racDisposables enumerateObjectsUsingBlock:^(RACDisposable * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj dispose];
    }];
    [self.sw_racDisposables removeAllObjects];
    [self.sw_racDisposables addObject:[self.sw_pagingQueryModel rac_observeKeyPath:@"hasMore" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        @strongify(self)
        self.mj_footer.hidden = !self.sw_pagingQueryModel.hasMore;
    }]];
    [self.sw_racDisposables addObject:[self.sw_pagingQueryModel rac_observeKeyPath:@"isFetchingMore" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        @strongify(self)
        self.mj_header.hidden = self.sw_pagingQueryModel.isFetchingMore;
    }]];
    [self.sw_racDisposables addObject:[self.sw_pagingQueryModel rac_observeKeyPath:@"fetchedData" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        @strongify(self)
        if(self.mj_header.isRefreshing){
            [self.mj_header endRefreshing];
        }
        if(!self.sw_pagingQueryModel.hasMore){
            if(self.sw_pagingQueryModel.fetchedData.count > 0){
                self.mj_footer.hidden = NO;
            }
            if(self.mj_footer.isRefreshing){
                [self.mj_footer endRefreshingWithNoMoreData];
            }else{
                if(self.mj_footer.state != MJRefreshStateNoMoreData){
                    [self.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }else{
            if(self.mj_footer.isRefreshing){
                [self.mj_footer endRefreshing];
            }
            if(self.mj_footer.state == MJRefreshStateNoMoreData){
                [self.mj_footer resetNoMoreData];
            }
        }
        if(self.sw_fetchListCompletedBlock){
            self.sw_fetchListCompletedBlock(self.sw_pagingQueryModel.fetchError,self.sw_pagingQueryModel.fetchedData);
        }
    }]];
}

- (void)sw_setCustomPagingQueryWithMjHeader:(MJRefreshNormalHeader *_Nullable)mjHeader mjFooter:(MJRefreshAutoNormalFooter *_Nullable)mjFooter pagingQueryModel:(SWBasePagingQueryModel *_Nonnull)pagingQueryModel completion:(SWFetchListCompletedBlock)fetchListCompletedBlock {
    [self sw_setCustomPagingQueryWithMjHeader:mjHeader mjFooter:mjFooter pagingQueryModel:pagingQueryModel willFetchBeginBlock:nil willFetchMoreBlock:nil completion:fetchListCompletedBlock];
}

- (void)sw_setDefaultPagingQueryWithModel:(SWBasePagingQueryModel *_Nonnull)pagingQueryModel completion:(SWFetchListCompletedBlock)fetchListCompletedBlock; {
    [self sw_setDefaultPagingQueryWithModel:pagingQueryModel willFetchBeginBlock:nil willFetchMoreBlock:nil completion:fetchListCompletedBlock];
}

- (void)sw_setDefaultPagingQueryWithModel:(SWBasePagingQueryModel *)pagingQueryModel pullRefreshBlock:(void (^)(void))pullRefreshBlock completion:(SWFetchListCompletedBlock)fetchListCompletedBlock __deprecated_msg("Use sw_setDefaultPagingQueryWithModel:willFetchBeginBlock:willFetchMoreBlock:completion:") {
    [self sw_setCustomPagingQueryWithMjHeader:[MJRefreshNormalHeader new] mjFooter:[MJRefreshAutoNormalFooter new] pagingQueryModel:pagingQueryModel pullRefreshBlock:pullRefreshBlock completion:fetchListCompletedBlock];
}

- (void)sw_setDefaultPagingQueryWithModel:(SWBasePagingQueryModel *)pagingQueryModel willFetchBeginBlock:(void (^)(void))willFetchBeginBlock willFetchMoreBlock:(void (^)(void))willFetchMoreBlock completion:(SWFetchListCompletedBlock)fetchListCompletedBlock {
    [self sw_setCustomPagingQueryWithMjHeader:[MJRefreshNormalHeader new] mjFooter:[MJRefreshAutoNormalFooter new] pagingQueryModel:pagingQueryModel willFetchBeginBlock:willFetchBeginBlock willFetchMoreBlock:willFetchMoreBlock completion:fetchListCompletedBlock];
}

- (void)setSw_pagingQueryModel:(SWBasePagingQueryModel *)sw_pagingQueryModel {
    objc_setAssociatedObject(self, @selector(sw_pagingQueryModel), sw_pagingQueryModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SWBasePagingQueryModel *)sw_pagingQueryModel {
    return objc_getAssociatedObject(self, @selector(sw_pagingQueryModel));
}

- (void)setSw_fetchListCompletedBlock:(SWFetchListCompletedBlock)sw_fetchListCompletedBlock {
    objc_setAssociatedObject(self, @selector(sw_fetchListCompletedBlock), sw_fetchListCompletedBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SWFetchListCompletedBlock)sw_fetchListCompletedBlock {
    return objc_getAssociatedObject(self, @selector(sw_fetchListCompletedBlock));
}

- (void)setSw_racDisposables:(NSMutableArray<RACDisposable *> *)sw_racDisposables {
    objc_setAssociatedObject(self, @selector(sw_racDisposables), sw_racDisposables, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray<RACDisposable *> *)sw_racDisposables {
    NSMutableArray *disposables = objc_getAssociatedObject(self, @selector(sw_racDisposables));
    if(!disposables){
        disposables = [NSMutableArray arrayWithCapacity:0];
        self.sw_racDisposables = disposables;
    }
    return disposables;
}






@end
