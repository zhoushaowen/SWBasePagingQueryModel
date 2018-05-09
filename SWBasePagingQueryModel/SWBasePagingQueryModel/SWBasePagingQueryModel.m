//
//  SWBasePagingQueryModel.m
//  SWBasePagingQueryModel
//
//  Created by zhoushaowen on 2018/5/8.
//  Copyright © 2018年 zhoushaowen. All rights reserved.
//

#import "SWBasePagingQueryModel.h"

@interface SWBasePagingQueryModel ()

@property (nonatomic,copy) NSArray *fetchedData;
@property (nonatomic) BOOL hasMore;
@property (nonatomic) BOOL isFetchingMore;
@property (nonatomic) BOOL isFetching;
@property (nonatomic) NSInteger currentFetchIndex;
@property (nonatomic,strong) NSError *fetchError;

@end

@implementation SWBasePagingQueryModel

- (void)fetchBeginning {
    if(self.isFetching) return;
    self.isFetching = YES;
    self.currentFetchIndex = 0;
    self.hasMore = NO;
    self.isFetchingMore = NO;
    self.fetchError = nil;
    [self asyncFetchWithPageIndex:self.currentFetchIndex completion:^(NSError *error, NSInteger totalCount, NSArray *result) {
        if(error){
            self.fetchError = error;
            [self willChangeValueForKey:@"fetchedData"];
            [self didChangeValueForKey:@"fetchedData"];
            self.isFetching = NO;
            return;
        }
        if(result.count < totalCount){
            self.hasMore = YES;;
        }else if (result.count > 0 && [self pageSize] <= result.count){
            self.hasMore = YES;
        }
        self.fetchedData = result;
        self.isFetching = NO;
    }];
}

- (void)fetchMore {
    if(!self.hasMore) return;
    if(self.isFetching) return;
    self.isFetching = YES;
    self.isFetchingMore = YES;
    self.fetchError = nil;
    [self asyncFetchWithPageIndex:++self.currentFetchIndex completion:^(NSError *error, NSInteger totalCount, NSArray *result) {
        if(error){
            self.fetchError = error;
            self.currentFetchIndex--;
            [self willChangeValueForKey:@"fetchedData"];
            [self didChangeValueForKey:@"fetchedData"];
            self.isFetchingMore = NO;
            self.isFetching = NO;
            return;
        }
        NSMutableArray *mutableArr = [self.fetchedData mutableCopy];
        [mutableArr addObjectsFromArray:result?:@[]];
        if(mutableArr.count < totalCount){
            self.hasMore = YES;;
        }else if (result.count > 0 && [self pageSize] <= result.count){
            self.hasMore = YES;
        }else{
            self.hasMore = NO;
        }
        self.fetchedData = mutableArr;
        self.isFetchingMore = NO;
        self.isFetching = NO;
    }];
}

- (void)asyncFetchWithPageIndex:(NSInteger)pageIndex completion:(void(^)(NSError *error, NSInteger totalCount, NSArray *result))completedBlock {
    [self doesNotRecognizeSelector:_cmd];
}

- (NSUInteger)pageSize {
    [self doesNotRecognizeSelector:_cmd];
    return 0;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
