//
//  UIScreenEdgePanGestureRecognizer+PrismIntercept.m
//  DiDiPrism
//
//  Created by hulk on 2019/10/15.
//

#import "UIScreenEdgePanGestureRecognizer+PrismIntercept.h"
#import <objc/runtime.h>
#import <RSSwizzle/RSSwizzle.h>
// Dispatcher
#import "PrismEventDispatcher.h"

// 响应链信息 +  gesture.edges = UIRectEdgeLeft;

@implementation UIScreenEdgePanGestureRecognizer (PrismIntercept)
#pragma mark - public method
/*
 不使用被动触发而是在load中进行，是因为
 必须及时swizzle，不然赶不上后退手势初始化。
 */
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Swizzle initWithTarget:action:
        RSSwizzleInstanceMethod(UIScreenEdgePanGestureRecognizer, @selector(initWithTarget:action:),
                                RSSWReturnType(UIScreenEdgePanGestureRecognizer *),
                                RSSWArguments(id target, SEL action),
                                RSSWReplacement({
            UIScreenEdgePanGestureRecognizer *gesture = RSSWCallOriginal(target, action);
            [gesture addTarget:self action:@selector(prism_autoDot_edgePanAction:)];
            return gesture;
        }),
                                RSSwizzleModeAlways,
                                NULL);

        // Swizzle addTarget:action:
        RSSwizzleInstanceMethod(UIScreenEdgePanGestureRecognizer, @selector(addTarget:action:),
                                RSSWReturnType(void),
                                RSSWArguments(id target, SEL action),
                                RSSWReplacement({
            RSSWCallOriginal(target, action);
            
            RSSWCallOriginal(self, @selector(prism_autoDot_edgePanAction:));
        }),
                                RSSwizzleModeAlways,
                                NULL);
        
        // Swizzle removeTarget:action:
        RSSwizzleInstanceMethod(UIScreenEdgePanGestureRecognizer, @selector(removeTarget:action:),
                                RSSWReturnType(void),
                                RSSWArguments(id target, SEL action),
                                RSSWReplacement({
            RSSWCallOriginal(target, action);
            
            RSSWCallOriginal(self, @selector(prism_autoDot_edgePanAction:));
        }),
                                RSSwizzleModeAlways,
                                NULL);
    });
}

#pragma mark - private method


#pragma mark - actions
- (void)prism_autoDot_edgePanAction:(UIScreenEdgePanGestureRecognizer*)edgePanGestureRecognizer {
    if ([UIScreenEdgePanGestureRecognizer prismHookEnable] == NO) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"target"] = self;
    params[@"action"] = NSStringFromSelector(@selector(prism_autoDot_edgePanAction:));
    [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIScreenEdgePanGestureRecognizerAction withSender:self params:[params copy]];
}

#pragma mark - property
- (NSNumber*)prismAutoDotViewControllerCount {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setPrismAutoDotViewControllerCount:(NSNumber*)prismAutoDotViewControllerCount {
    objc_setAssociatedObject(self, @selector(prismAutoDotViewControllerCount), prismAutoDotViewControllerCount, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UINavigationController*)prismAutoDotNavigationController {
    UINavigationController* (^block)(void) = objc_getAssociatedObject(self, @selector(prismAutoDotNavigationController));
    return (block ? block() : nil);
}
- (void)setPrismAutoDotNavigationController:(UINavigationController*)prismAutoDotNavigationController {
    __weak UINavigationController *weakController = prismAutoDotNavigationController;
    UINavigationController* (^block)(void) = ^{ return weakController; };
    objc_setAssociatedObject(self, @selector(prismAutoDotNavigationController), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (BOOL)prismHookEnable {
    NSNumber *hookEnable = objc_getAssociatedObject(self, _cmd);
    return [hookEnable boolValue];
}
+ (void)setPrismHookEnable:(BOOL)hookEnable {
    objc_setAssociatedObject(self, @selector(prismHookEnable), [NSNumber numberWithBool:hookEnable], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
