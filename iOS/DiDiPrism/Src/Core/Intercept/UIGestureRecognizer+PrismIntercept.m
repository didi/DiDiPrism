//
//  UIGestureRecognizer+PrismIntercept.m
//  DiDiPrism
//
//  Created by hulk on 2025/2/8.
//

#import "UIGestureRecognizer+PrismIntercept.h"
#import <objc/runtime.h>
#import <RSSwizzle/RSSwizzle.h>
// Dispatcher
#import "PrismEventDispatcher.h"

@implementation UIGestureRecognizer (PrismIntercept)
#pragma mark - public method
+ (void)prism_swizzleMethodIMP {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // Swizzle ReactNative框架中自定义触控手势的setState:方法
        Class reactNativeHiddenClass = objc_getClass("RCTSurfaceTouchHandler");
        SEL reactNativeHiddenSelector = @selector(setState:);
        if (reactNativeHiddenClass && class_getInstanceMethod(reactNativeHiddenClass, reactNativeHiddenSelector)) {
            
            RSSwizzleInstanceMethod(reactNativeHiddenClass, reactNativeHiddenSelector,
                                    RSSWReturnType(void),
                                    RSSWArguments(UIGestureRecognizerState state),
                                    RSSWReplacement({
                RSSWCallOriginal(state);
                SEL swizzleSelector = NSSelectorFromString(@"prism_autoDot_RN_setState:");
                Method swizzleMethod = class_getInstanceMethod([UIGestureRecognizer class], swizzleSelector);
                IMP swizzleMethodImp =  method_getImplementation(swizzleMethod);
                void (*functionPointer)(id, SEL, UIGestureRecognizerState) = (void (*)(id, SEL, UIGestureRecognizerState))swizzleMethodImp;
                functionPointer(self, _cmd, state);
            }),
                                    RSSwizzleModeAlways,
                                    NULL);
            
        }
    });
}

#pragma mark - private method
- (void)prism_autoDot_RN_setState:(UIGestureRecognizerState)state {
    // set逻辑后 state 和 self.state 应一致，某些场景下self.state依然为UIGestureRecognizerStateFailed不符合预期。
    if (state == UIGestureRecognizerStateRecognized && self.state == UIGestureRecognizerStateRecognized) {
        [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventRCTSurfaceTouchHandlerSetState withSender:self params:nil];
    }
}

@end
