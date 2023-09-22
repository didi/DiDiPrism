//
//  UILongPressGestureRecognizer+PrismIntercept.m
//  DiDiPrism
//
//  Created by hulk on 2021/6/23.
//

#import "UILongPressGestureRecognizer+PrismIntercept.h"
#import <objc/runtime.h>
#import <RSSwizzle/RSSwizzle.h>
// Dispatcher
#import "PrismEventDispatcher.h"
// Util
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
        // Swizzle setState:
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

        // Swizzle initWithTarget:action:
        RSSwizzleInstanceMethod(UILongPressGestureRecognizer, @selector(initWithTarget:action:),
                                RSSWReturnType(UILongPressGestureRecognizer *),
                                RSSWArguments(id target, SEL action),
                                RSSWReplacement({
            UILongPressGestureRecognizer *gesture = RSSWCallOriginal(target, action);
            
            [gesture addTarget:self action:@selector(prism_autoDot_longPressAction:)];
            // 通过[[xxx alloc] init]初始化时，target和action为nil，影响生成结果，故作此判断。
            if (target && action) {
                gesture.prismAutoDotTargetAndSelector = [NSString stringWithFormat:@"%@_&_%@", NSStringFromClass([target class]), NSStringFromSelector(action)];
            }
            else {
                gesture.prismAutoDotTargetAndSelector = @"";
            }
            
            return gesture;
        }),
                                RSSwizzleModeAlways,
                                NULL);

        // Swizzle addTarget:action:
        RSSwizzleInstanceMethod(UILongPressGestureRecognizer, @selector(addTarget:action:),
                                RSSWReturnType(void),
                                RSSWArguments(id target, SEL action),
                                RSSWReplacement({
            RSSWCallOriginal(target, action);
            
            RSSWCallOriginal(self, @selector(prism_autoDot_longPressAction:));
            SEL swizzleSelector = NSSelectorFromString(@"prism_autoDot_addTarget:action:");
            Method swizzleMethod = class_getInstanceMethod([UITapGestureRecognizer class], swizzleSelector);
            IMP swizzleMethodImp =  method_getImplementation(swizzleMethod);
            void (*functionPointer)(id, SEL, id, SEL) = (void (*)(id, SEL, id, SEL))swizzleMethodImp;
            functionPointer(self, _cmd, target, action);
        }),
                                RSSwizzleModeAlways,
                                NULL);
        
        // Swizzle removeTarget:action:
        RSSwizzleInstanceMethod(UILongPressGestureRecognizer, @selector(removeTarget:action:),
                                RSSWReturnType(void),
                                RSSWArguments(id target, SEL action),
                                RSSWReplacement({
            RSSWCallOriginal(target, action);
            
            RSSWCallOriginal(self, @selector(prism_autoDot_longPressAction:));
            SEL swizzleSelector = NSSelectorFromString(@"prism_autoDot_removeTarget:action:");
            Method swizzleMethod = class_getInstanceMethod([UITapGestureRecognizer class], swizzleSelector);
            IMP swizzleMethodImp =  method_getImplementation(swizzleMethod);
            void (*functionPointer)(id, SEL, id, SEL) = (void (*)(id, SEL, id, SEL))swizzleMethodImp;
            functionPointer(self, _cmd, target, action);
        }),
                                RSSwizzleModeAlways,
                                NULL);
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

- (void)prism_autoDot_addTarget:(id)target action:(SEL)action {
    if (!self.prismAutoDotTargetAndSelector.length) {
        self.prismAutoDotTargetAndSelector = [NSString stringWithFormat:@"%@_&_%@", NSStringFromClass([target class]), NSStringFromSelector(action)];
    }
}

- (void)prism_autoDot_removeTarget:(id)target action:(SEL)action {
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
