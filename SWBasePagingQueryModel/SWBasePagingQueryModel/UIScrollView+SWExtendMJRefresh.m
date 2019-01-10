//
//  UIScrollView+SWExtendMJRefresh.m
//  SWBasePagingQueryModel
//
//  Created by zhoushaowen on 2018/6/13.
//  Copyright © 2018年 zhoushaowen. All rights reserved.
//

#import "UIScrollView+SWExtendMJRefresh.h"
#import <MJRefresh.h>
#import <objc/runtime.h>
#import <NSObject+RACKVOWrapper.h>
#import <RACEXTScope.h>
#import <RACDisposable.h>

@interface UIScrollView ()

@property (nonatomic,strong) RACDisposable *sw_MjHeaderPullRefreshDisposable;

@end

@implementation UIScrollView (SWExtendMJRefresh)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL oriSel = @selector(setMj_header:);
        SEL repSel = @selector(setSW_Mj_header:);
        Method mjMethod = class_getInstanceMethod([self class], oriSel);
        Method myMethod = class_getInstanceMethod([self class], repSel);
        if(class_addMethod([self class], oriSel, method_getImplementation(myMethod), method_getTypeEncoding(myMethod))){
            class_replaceMethod([self class], repSel, method_getImplementation(mjMethod), method_getTypeEncoding(mjMethod));
        }else{
            method_exchangeImplementations(mjMethod, myMethod);
        }
    });
}

- (void)setSW_Mj_header:(MJRefreshHeader *)mj_header {
    [self setSW_Mj_header:mj_header];
    if(self.sw_MjHeaderPullRefreshDisposable){
        [self.sw_MjHeaderPullRefreshDisposable dispose];
        self.sw_MjHeaderPullRefreshDisposable = nil;
    }
    @weakify(self)
    self.sw_MjHeaderPullRefreshDisposable = [self.mj_header rac_observeKeyPath:@"state" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        @strongify(self)
        if(self.sw_disableMjHeaderPullRefreshFeedback) return;
        if(self.mj_header.state == MJRefreshStatePulling){
            if (@available(iOS 10.0, *)) {
                UIImpactFeedbackGenerator *feedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
                [feedback prepare];
                [feedback impactOccurred];
            }
        }
    }];
}

- (void)setSw_disableMjHeaderPullRefreshFeedback:(BOOL)sw_disableMjHeaderPullRefreshFeedback {
    objc_setAssociatedObject(self, @selector(sw_disableMjHeaderPullRefreshFeedback), @(sw_disableMjHeaderPullRefreshFeedback), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)sw_disableMjHeaderPullRefreshFeedback {
    return [objc_getAssociatedObject(self, @selector(sw_disableMjHeaderPullRefreshFeedback)) boolValue];
}

- (void)setSw_MjHeaderPullRefreshDisposable:(RACDisposable *)sw_MjHeaderPullRefreshDisposable {
    objc_setAssociatedObject(self, @selector(sw_MjHeaderPullRefreshDisposable), sw_MjHeaderPullRefreshDisposable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (RACDisposable *)sw_MjHeaderPullRefreshDisposable {
    return objc_getAssociatedObject(self, @selector(sw_MjHeaderPullRefreshDisposable));
}

@end
