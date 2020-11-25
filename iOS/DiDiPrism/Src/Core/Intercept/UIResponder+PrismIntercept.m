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
- (NSString *)autoDotItemName {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setAutoDotItemName:(NSString *)autoDotItemName {
    objc_setAssociatedObject(self, @selector(autoDotItemName), autoDotItemName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)autoDotSpecialMark {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setAutoDotSpecialMark:(NSString *)autoDotSpecialMark {
    objc_setAssociatedObject(self, @selector(autoDotSpecialMark), autoDotSpecialMark, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)autoDotFinalMark {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setAutoDotFinalMark:(NSString *)autoDotFinalMark {
    objc_setAssociatedObject(self, @selector(autoDotFinalMark), autoDotFinalMark, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
