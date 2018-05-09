//
//  MyPagingQueryModel.m
//  SWBasePagingQueryModel
//
//  Created by zhoushaowen on 2018/5/8.
//  Copyright © 2018年 zhoushaowen. All rights reserved.
//

#import "MyPagingQueryModel.h"

@implementation MyPagingQueryModel

- (NSUInteger)pageSize {
    return 20;
}

- (void)asyncFetchWithPageIndex:(NSInteger)pageIndex completion:(void(^)(NSError *error, NSInteger totalCount, NSArray *result))completedBlock {
    NSLog(@"%ld",(long)pageIndex);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        switch (pageIndex) {
            case 3:
            {
                static BOOL flag = NO;
                if(!flag){
                    flag = YES;
                    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:@"网络错误!"}];
                    completedBlock(error,0,nil);
                }else{
                    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:20];
                    for(int i=0;i<[self pageSize];i++){
                        [arr addObject:@"测试数据"];
                    }
                    completedBlock(nil,0,arr);
                }
            }
                break;
                case 5:
            {
                NSMutableArray *arr = [NSMutableArray arrayWithCapacity:20];
                for(int i=0;i<3;i++){
                    [arr addObject:@"测试数据"];
                }
                completedBlock(nil,0,arr);
            }
                break;
                
            default:
            {
                NSMutableArray *arr = [NSMutableArray arrayWithCapacity:20];
                for(int i=0;i<[self pageSize];i++){
                    [arr addObject:@"测试数据"];
                }
                completedBlock(nil,0,arr);
            }
                break;
        }
    });
}

@end
