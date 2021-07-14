//
//  UILongPressGestureRecognizer+PrismIntercept.m
//  DiDiPrism
//
//  Created by hulk on 2021/6/23.
//

#import "UILongPressGestureRecognizer+PrismIntercept.h"
#import <RSSwizzle/RSSwizzle.h>
// Dispatcher
#import "PrismEventDispatcher.h"
// Util
#import "PrismRuntimeUtil.h"
#import "PrismInstructionAreaInfoUtil.h"
#import "PrismInstructionResponseChainInfoUtil.h"
// Category
#import "UIResponder+PrismIntercept.h"
#import "UIGestureRecognizer+PrismExtends.h"

@implementation UILongPressGestureRecognizer (PrismIntercept)
#pragma mark - public method
+ (void)prism_swizzleMethodIMP {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RSSwizzleInstanceMethod(UILongPressGestureRecognizer, @selector(setState:),
                                RSSWReturnType(void),
                                RSSWArguments(UIGestureRecognizerState state),
                                RSSWReplacement({
            RSSWCallOriginal(state);
            SEL swizzleSelector = NSSelectorFromString(@"prism_autoDot_setState:");
            Method swizzleMethod = class_getInstanceMethod([UILongPressGestureRecognizer class], swizzleSelector);
            IMP swizzleMethodImp =  method_getImplementation(swizzleMethod);
            void (*functionPointer)(id, SEL, UIGestureRecognizerState) = (void (*)(id, SEL, UIGestureRecognizerState))swizzleMethodImp;
            functionPointer(self, _cmd, state);
        }),
                                RSSwizzleModeAlways,
                                NULL);

        
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(initWithTarget:action:) swizzledSelector:@selector(prism_autoDot_initWithTarget:action:)];
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(addTarget:action:) swizzledSelector:@selector(prism_autoDot_addTarget:action:)];
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(removeTarget:action:) swizzledSelector:@selector(prism_autoDot_removeTarget:action:)];
    });
}

#pragma mark - private method
- (void)prism_autoDot_setState:(UIGestureRecognizerState)state {
    // set逻辑后 state 和 self.state 应一致，某些场景下self.state依然为UIGestureRecognizerStateFailed不符合预期。
    if (state == UIGestureRecognizerStateRecognized && self.state == UIGestureRecognizerStateRecognized) {
        //注1：没有选择在setState阶段直接进行event id的收集，是因为类似于WEEX场景中一次操作可以识别到多个手势（区别于实际起作用的手势）。
        //注2：选择在setState阶段先收集响应链信息和区位信息，是因为有些场景下点击事件触发后view.superview可能为nil，需提前捕捉。
        if ([self.view superview]) {
            NSString *responseChainInfo = [PrismInstructionResponseChainInfoUtil getResponseChainInfoWithElement:self.view];
            if (responseChainInfo.length) {
                [self setPrismAutoDotResponseChainInfo:responseChainInfo];
            }
            NSArray *areaInfo = [PrismInstructionAreaInfoUtil getAreaInfoWithElement:self.view];
            if (areaInfo.count) {
                [self setPrismAutoDotAreaInfo:areaInfo];
            }
        }
    }
}


- (instancetype)prism_autoDot_initWithTarget:(id)target action:(SEL)action {
    //原始逻辑
    UILongPressGestureRecognizer *gesture = [self prism_autoDot_initWithTarget:target action:action];
    
    [gesture addTarget:self action:@selector(prism_autoDot_longPressAction:)];
    gesture.prismAutoDotTargetAndSelector = [NSString stringWithFormat:@"%@_&_%@", NSStringFromClass([target class]), NSStringFromSelector(action)];
    
    return gesture;
}

- (void)prism_autoDot_addTarget:(id)target action:(SEL)action {
    //原始逻辑
    [self prism_autoDot_addTarget:target action:action];
    
    [self prism_autoDot_addTarget:self action:@selector(prism_autoDot_longPressAction:)];
    if (!self.prismAutoDotTargetAndSelector.length) {
        self.prismAutoDotTargetAndSelector = [NSString stringWithFormat:@"%@_&_%@", NSStringFromClass([target class]), NSStringFromSelector(action)];
    }
}

- (void)prism_autoDot_removeTarget:(id)target action:(SEL)action {
    //原始逻辑
    [self prism_autoDot_removeTarget:target action:action];
    
    [self prism_autoDot_removeTarget:self action:@selector(prism_autoDot_longPressAction:)];
    self.prismAutoDotTargetAndSelector = @"";
}

#pragma mark - actions
- (void)prism_autoDot_longPressAction:(UILongPressGestureRecognizer*)longPressGestureRecognizer {
    if (longPressGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"target"] = self;
        params[@"action"] = NSStringFromSelector(@selector(prism_autoDot_longPressAction:));
        [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUILongPressGestureRecognizerAction withSender:self params:[params copy]];
    }
}
@end
