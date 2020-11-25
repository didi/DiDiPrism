//
//  PrismRuntimeUtil.m
//  DiDiPrism
//
//  Created by hulk on 2019/6/27.
//

#import "PrismRuntimeUtil.h"
#import "PrismBehaviorRecordManager.h"

@implementation PrismRuntimeUtil
+ (void)hookClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    [self hookClass:cls originalSelector:originalSelector swizzledSelector:swizzledSelector isClassMethod:NO];
}

+ (void)hookClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector isClassMethod:(BOOL)isClassMethod {
    Method originalMethod = isClassMethod ? class_getClassMethod(cls, originalSelector) : class_getInstanceMethod(cls, originalSelector);
    Method swizzledMethod = isClassMethod ? class_getClassMethod(cls, swizzledSelector) : class_getInstanceMethod(cls, swizzledSelector);
    
    BOOL success = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
@end
