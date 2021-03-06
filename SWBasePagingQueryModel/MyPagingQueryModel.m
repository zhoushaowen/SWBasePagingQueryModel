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
    return 5;
}

- (void)asyncFetchWithPageIndex:(NSInteger)pageIndex completion:(void(^)(NSError *error, NSInteger totalCount, NSArray *result))completedBlock {
    NSLog(@"%ld",(long)pageIndex);
    //模拟假的网路请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        switch (pageIndex) {
            case 3:
            {
                static BOOL flag = NO;
                if(!flag){
                    flag = YES;
                    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:@"网络错误!"}];
                    completedBlock(error,SWUnknownCount,nil);
                }else{
                    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];
                    for(int i=0;i<[self pageSize];i++){
                        [arr addObject:@"测试数据"];
                    }
                    completedBlock(nil,SWUnknownCount,arr);
                }
            }
                break;
                case 5:
            {
                NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];
                for(int i=0;i<3;i++){
                    [arr addObject:@"测试数据"];
                }
                completedBlock(nil,SWUnknownCount,arr);
            }
                break;
                
            default:
            {
                NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];
                for(int i=0;i<[self pageSize];i++){
                    [arr addObject:@"测试数据"];
                }
                completedBlock(nil,SWUnknownCount,arr);
            }
                break;
        }
    });
}

@end
