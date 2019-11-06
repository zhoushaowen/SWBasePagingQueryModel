//
//  SWNormalPagingQueryModel.h
//  SWBasePagingQueryModel
//
//  Created by zhoushaowen on 2019/11/6.
//  Copyright © 2019 zhoushaowen. All rights reserved.
//

#import "SWBasePagingQueryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SWNormalPagingQueryModel : SWBasePagingQueryModel

- (void)normalAsyncFetchWithPageIndex:(NSInteger)pageIndex completion:(void(^_Nonnull)(BOOL isSucess,NSString * _Nullable errorMsg,NSArray * _Nullable resultArray))completedBlock;

@end

NS_ASSUME_NONNULL_END
