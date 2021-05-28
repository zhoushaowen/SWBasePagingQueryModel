//
//  SWNormalPagingQueryModel.m
//  SWBasePagingQueryModel
//
//  Created by zhoushaowen on 2019/11/6.
//  Copyright © 2019 zhoushaowen. All rights reserved.
//

#import "SWNormalPagingQueryModel.h"

@implementation SWNormalPagingQueryModel

- (NSInteger)fetchBeginIndex {
    return 1;
}

- (void)asyncFetchWithPageIndex:(NSInteger)pageIndex completion:(void(^_Nonnull)(NSError * _Nullable error, NSInteger totalCount, NSArray * _Nullable result))completedBlock {
    [self normalAsyncFetchWithPageIndex:pageIndex completion:^(BOOL isSucess, NSString * _Nullable errorMsg, NSArray * _Nullable resultArray) {
        if(isSucess){
            completedBlock(nil,SWUnknownCount,resultArray);
        }else{
            completedBlock([NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUnknown userInfo:@{NSLocalizedDescriptionKey:errorMsg?:@""}],SWUnknownCount,nil);
        }
    }];
}

- (void)normalAsyncFetchWithPageIndex:(NSInteger)pageIndex completion:(void(^_Nonnull)(BOOL isSucess,NSString * _Nullable errorMsg,NSArray * _Nullable resultArray))completedBlock {
    [self doesNotRecognizeSelector:_cmd];
}


@end
