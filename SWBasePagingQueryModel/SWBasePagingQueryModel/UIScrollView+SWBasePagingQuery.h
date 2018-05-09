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

@property (nonatomic,readonly,strong) SWBasePagingQueryModel *pagingQueryModel;
@property (nonatomic,readonly,strong) SWFetchListCompletedBlock fetchListCompletedBlock;

- (void)setDefaultPagingQueryWithModel:(SWBasePagingQueryModel *)pagingQueryModel completion:(SWFetchListCompletedBlock)fetchListCompletedBlock;
- (void)setCustomPagingQueryWithMjHeader:(MJRefreshNormalHeader *)mjHeader mjfooter:(MJRefreshAutoNormalFooter *)mjFooter pagingQueryModel:(SWBasePagingQueryModel *)pagingQueryModel completion:(SWFetchListCompletedBlock)fetchListCompletedBlock;

@end
