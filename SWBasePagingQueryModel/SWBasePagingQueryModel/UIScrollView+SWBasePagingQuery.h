//
//  UIScrollView+SWBasePagingQuery.h
//  SWBasePagingQueryModel
//
//  Created by zhoushaowen on 2018/5/9.
//  Copyright © 2018年 zhoushaowen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SWBasePagingQueryModel;
@class MJRefreshNormalHeader;
@class MJRefreshAutoNormalFooter;

typedef void(^SWFetchListCompletedBlock)(NSError *error,NSArray *fetchedData);

@interface UIScrollView (SWBasePagingQuery)

@property (nonatomic,readonly,strong) SWBasePagingQueryModel *sw_pagingQueryModel;
@property (nonatomic,readonly,strong) SWFetchListCompletedBlock sw_fetchListCompletedBlock;

///  为UIScrollView添加默认样式的下拉刷新和上拉加载(默认是既有下拉刷新和上拉加载更多)
/// @param pagingQueryModel pagingQueryModel
/// @param willFetchBeginBlock 即将下拉刷新的回调
/// @param willFetchMoreBlock 即将上拉加载更多的回调
/// @param fetchListCompletedBlock 刷新完成的回调
- (void)sw_setDefaultPagingQueryWithModel:(SWBasePagingQueryModel *)pagingQueryModel willFetchBeginBlock:(void (^_Nullable)(void))willFetchBeginBlock willFetchMoreBlock:(void (^_Nullable)(void))willFetchMoreBlock completion:(SWFetchListCompletedBlock)fetchListCompletedBlock;

/// 为UIScrollView添加自定义样式的下拉刷新和上拉加载
/// @param mjHeader mjHeader
/// @param mjFooter mjFooter
/// @param pagingQueryModel pagingQueryModel
/// @param willFetchBeginBlock 即将下拉刷新的回调
/// @param willFetchMoreBlock 即将上拉加载更多的回调
/// @param fetchListCompletedBlock 刷新完成的回调
- (void)sw_setCustomPagingQueryWithMjHeader:(MJRefreshNormalHeader *_Nullable)mjHeader mjFooter:(MJRefreshAutoNormalFooter *_Nullable)mjFooter pagingQueryModel:(SWBasePagingQueryModel *)pagingQueryModel willFetchBeginBlock:(void(^_Nullable)(void))willFetchBeginBlock willFetchMoreBlock:(void(^_Nullable)(void))willFetchMoreBlock completion:(SWFetchListCompletedBlock)fetchListCompletedBlock;
/**
 为UIScrollView添加默认样式的下拉刷新和上拉加载(默认是既有下拉刷新和上拉加载更多)
 */
- (void)sw_setDefaultPagingQueryWithModel:(SWBasePagingQueryModel *_Nonnull)pagingQueryModel completion:(SWFetchListCompletedBlock)fetchListCompletedBlock;

/**
 为UIScrollView添加自定义样式的下拉刷新和上拉加载
 */
- (void)sw_setCustomPagingQueryWithMjHeader:(MJRefreshNormalHeader *_Nullable)mjHeader mjFooter:(MJRefreshAutoNormalFooter *_Nullable)mjFooter pagingQueryModel:(SWBasePagingQueryModel *)pagingQueryModel completion:(SWFetchListCompletedBlock)fetchListCompletedBlock;

/**
 为UIScrollView添加自定义样式的下拉刷新和上拉加载

 @param pullRefreshBlock 下拉刷新的回调
 */
- (void)sw_setCustomPagingQueryWithMjHeader:(MJRefreshNormalHeader *_Nullable)mjHeader mjFooter:(MJRefreshAutoNormalFooter *_Nullable)mjFooter pagingQueryModel:(SWBasePagingQueryModel *_Nonnull)pagingQueryModel pullRefreshBlock:(void(^)(void))pullRefreshBlock completion:(SWFetchListCompletedBlock)fetchListCompletedBlock __deprecated_msg("Use sw_setCustomPagingQueryWithMjHeader:mjFooter:pagingQueryModel:willFetchBeginBlock:willFetchMoreBlock:completion:");
/**
 为UIScrollView添加默认样式的下拉刷新和上拉加载,是否需要下拉刷新可以通过isEnablePullRefresh控制
 */
- (void)sw_setDefaultPagingQueryWithModel:(SWBasePagingQueryModel *_Nonnull)pagingQueryModel enablePullRefresh:(BOOL)isEnablePullRefresh completion:(SWFetchListCompletedBlock)fetchListCompletedBlock __deprecated_msg("Use sw_setCustomPagingQueryWithMjHeader:mjFooter:pagingQueryModel:completion:");
/**
 为UIScrollView添加默认样式的下拉刷新和上拉加载(默认是既有下拉刷新和上拉加载更多)
 
 @param pullRefreshBlock 下拉刷新的回调
 */
- (void)sw_setDefaultPagingQueryWithModel:(SWBasePagingQueryModel *_Nonnull)pagingQueryModel pullRefreshBlock:(void(^)(void))pullRefreshBlock completion:(SWFetchListCompletedBlock)fetchListCompletedBlock __deprecated_msg("Use sw_setDefaultPagingQueryWithModel:willFetchBeginBlock:willFetchMoreBlock:completion:");


@end

NS_ASSUME_NONNULL_END
