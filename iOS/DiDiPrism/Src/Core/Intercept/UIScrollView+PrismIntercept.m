//
//  UIScrollView+PrismIntercept.m
//  DiDiPrism
//
//  Created by hulk on 2021/8/19.
//

#import "UIScrollView+PrismIntercept.h"
#import <objc/runtime.h>
#import <RSSwizzle/RSSwizzle.h>
// Dispatcher
#import "PrismEventDispatcher.h"

@implementation UIScrollView (PrismIntercept)
#pragma mark - public method
+ (void)prism_swizzleMethodIMP {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Swizzle setContentOffset:
        RSSwizzleInstanceMethod(UIScrollView, @selector(setContentOffset:),
                                RSSWReturnType(void),
                                RSSWArguments(CGPoint contentOffset),
                                RSSWReplacement({
            RSSWCallOriginal(contentOffset);
            
            SEL swizzleSelector = NSSelectorFromString(@"prism_autoDot_setContentOffset:");
            Method swizzleMethod = class_getInstanceMethod([UIScrollView class], swizzleSelector);
            IMP swizzleMethodImp =  method_getImplementation(swizzleMethod);
            void (*functionPointer)(id, SEL, CGPoint) = (void (*)(id, SEL, CGPoint))swizzleMethodImp;
            functionPointer(self, _cmd, contentOffset);
        }),
                                RSSwizzleModeAlways,
                                NULL);
    });
}

#pragma mark - private method
- (void)prism_autoDot_setContentOffset:(CGPoint)contentOffset {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"contentOffset"] = [NSValue valueWithCGPoint:contentOffset];
    [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIScrollViewSetContentOffset withSender:self params:[params copy]];
}
@end
