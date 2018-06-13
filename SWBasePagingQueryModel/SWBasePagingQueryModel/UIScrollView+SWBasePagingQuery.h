//
//  UIScrollView+SWBasePagingQuery.h
//  SWBasePagingQueryModel
//
//  Created by zhoushaowen on 2018/5/9.
//  Copyright © 2018年 zhoushaowen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWBasePagingQueryModel;
@class MJRefreshNormalHeader;
@class MJRefreshAutoNormalFooter;

typedef void(^SWFetchListCompletedBlock)(NSError *error);

@interface UIScrollView (SWBasePagingQuery)

@property (nonatomic,readonly,strong) SWBasePagingQueryModel *sw_pagingQueryModel;
@property (nonatomic,readonly,strong) SWFetchListCompletedBlock sw_fetchListCompletedBlock;

- (void)sw_setDefaultPagingQueryWithModel:(SWBasePagingQueryModel *)pagingQueryModel completion:(SWFetchListCompletedBlock)fetchListCompletedBlock;
- (void)sw_setCustomPagingQueryWithMjHeader:(MJRefreshNormalHeader *)mjHeader mjFooter:(MJRefreshAutoNormalFooter *)mjFooter pagingQueryModel:(SWBasePagingQueryModel *)pagingQueryModel completion:(SWFetchListCompletedBlock)fetchListCompletedBlock;

@end
