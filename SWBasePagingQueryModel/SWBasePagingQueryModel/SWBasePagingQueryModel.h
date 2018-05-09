//
//  SWBasePagingQueryModel.h
//  SWBasePagingQueryModel
//
//  Created by zhoushaowen on 2018/5/8.
//  Copyright © 2018年 zhoushaowen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWBasePagingQueryModel : NSObject

#pragma mark - KVO

/**
 获取到的列表数据
 */
@property (nullable,nonatomic,readonly,copy) NSArray *fetchedData;

/**
 获取数据时发生的错误
 */
@property (nullable,nonatomic,readonly,strong) NSError *fetchError;

/**
 是否有更多数据支持下一页刷新
 */
@property (nonatomic,readonly) BOOL hasMore;

/**
 是否正在加载更多数据
 */
@property (nonatomic,readonly) BOOL isFetchingMore;

#pragma mark - Invoke

/**
 下拉刷新
 */
- (void)fetchBeginning;

/**
 加载更多
 */
- (void)fetchMore;

#pragma mark - Overrid

/**
 网络异步请求,你需要重写此方法

 @param pageIndex 刷新的索引,从0开始
 @param completedBlock 异步请求完成的block,在网络请求结束之后必须要调用此block
 */
- (void)asyncFetchWithPageIndex:(NSInteger)pageIndex completion:(void(^)(NSError *error, NSInteger totalCount, NSArray *result))completedBlock;

/**
 每页数据的数量,你需要重写此方法
 */
- (NSUInteger)pageSize;

@end