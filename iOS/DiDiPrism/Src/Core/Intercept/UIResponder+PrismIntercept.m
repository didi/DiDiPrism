//
//  UIResponder+PrismIntercept.m
//  DiDiPrism
//
//  Created by hulk on 2019/6/27.
//

#import "UIResponder+PrismIntercept.h"
// Util
#import "PrismRuntimeUtil.h"

@implementation UIResponder (PrismIntercept)

#pragma mark - property
- (NSString *)prismAutoDotItemName {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setPrismAutoDotItemName:(NSString *)prismAutoDotItemName {
    objc_setAssociatedObject(self, @selector(prismAutoDotItemName), prismAutoDotItemName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)prismAutoDotSpecialMark {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setPrismAutoDotSpecialMark:(NSString *)prismAutoDotSpecialMark {
    objc_setAssociatedObject(self, @selector(prismAutoDotSpecialMark), prismAutoDotSpecialMark, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)prismAutoDotFinalMark {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setPrismAutoDotFinalMark:(NSString *)prismAutoDotFinalMark {
    objc_setAssociatedObject(self, @selector(prismAutoDotFinalMark), prismAutoDotFinalMark, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
