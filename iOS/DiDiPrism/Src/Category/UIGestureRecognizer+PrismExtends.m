//
//  UIGestureRecognizer+PrismExtends.m
//  DiDiPrism
//
//  Created by hulk on 2021/6/23.
//

#import "UIGestureRecognizer+PrismExtends.h"
#import <objc/runtime.h>

@implementation UIGestureRecognizer (PrismExtends)
#pragma mark - property
- (NSString *)prismAutoDotTargetAndSelector {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setPrismAutoDotTargetAndSelector:(NSString *)prismAutoDotTargetAndSelector {
    objc_setAssociatedObject(self, @selector(prismAutoDotTargetAndSelector), prismAutoDotTargetAndSelector, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)prismAutoDotResponseChainInfo {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setPrismAutoDotResponseChainInfo:(NSString *)prismAutoDotResponseChainInfo {
    objc_setAssociatedObject(self, @selector(prismAutoDotResponseChainInfo), prismAutoDotResponseChainInfo, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSArray *)prismAutoDotAreaInfo {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setPrismAutoDotAreaInfo:(NSArray *)prismAutoDotAreaInfo {
    objc_setAssociatedObject(self, @selector(prismAutoDotAreaInfo), prismAutoDotAreaInfo, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
