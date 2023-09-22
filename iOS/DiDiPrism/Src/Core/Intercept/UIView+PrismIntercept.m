//
//  UIView+PrismIntercept.m
//  DiDiPrism
//
//  Created by hulk on 2019/7/2.
//

#import "UIView+PrismIntercept.h"
#import <objc/runtime.h>
#import <RSSwizzle/RSSwizzle.h>
// Dispatcher
#import "PrismEventDispatcher.h"

@implementation UIView (PrismIntercept)
#pragma mark - public method
+ (void)prism_swizzleMethodIMP {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Swizzle touchesEnded:withEvent:
        // 考虑到可能的手势影响，选择hook touchesEnded:withEvent:更合理。
        RSSwizzleInstanceMethod(UIView, @selector(touchesEnded:withEvent:),
                                RSSWReturnType(void),
                                RSSWArguments(NSSet<UITouch *> *touches, UIEvent *event),
                                RSSWReplacement({
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            UITouch *touch = [touches anyObject];
            if (touch) {
                [params setObject:touch forKey:@"touch"];
            }
            [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIViewTouchesEnded_Start withSender:self params:[params copy]];
            
            RSSWCallOriginal(touches, event);
            
            [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIViewTouchesEnded_End withSender:self params:[params copy]];
        }),
                                RSSwizzleModeAlways,
                                NULL);
        
        // Swizzle didMoveToSuperview
        RSSwizzleInstanceMethod(UIView, @selector(didMoveToSuperview),
                                RSSWReturnType(void),
                                RSSWArguments(),
                                RSSWReplacement({
            RSSWCallOriginal();
            
            [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIViewDidMoveToSuperview withSender:self params:nil];
        }),
                                RSSwizzleModeAlways,
                                NULL);
        
        // Swizzle didMoveToWindow
        RSSwizzleInstanceMethod(UIView, @selector(didMoveToWindow),
                                RSSWReturnType(void),
                                RSSWArguments(),
                                RSSWReplacement({
            RSSWCallOriginal();
            
            [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIViewDidMoveToWindow withSender:self params:nil];
        }),
                                RSSwizzleModeAlways,
                                NULL);
        
        // Swizzle setFrame:
        RSSwizzleInstanceMethod(UIView, @selector(setFrame:),
                                RSSWReturnType(void),
                                RSSWArguments(CGRect frame),
                                RSSWReplacement({
            RSSWCallOriginal(frame);
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"frame"] = [NSValue valueWithCGRect:frame];
            [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIViewSetFrame withSender:self params:[params copy]];
        }),
                                RSSwizzleModeAlways,
                                NULL);
        
        // Swizzle setHidden:
        RSSwizzleInstanceMethod(UIView, @selector(setHidden:),
                                RSSWReturnType(void),
                                RSSWArguments(BOOL hidden),
                                RSSWReplacement({
            RSSWCallOriginal(hidden);
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"hidden"] = [NSNumber numberWithBool:hidden];
            [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIViewSetHidden withSender:self params:[params copy]];
        }),
                                RSSwizzleModeAlways,
                                NULL);
    });
}

#pragma mark - private method
// 考虑到可能的手势影响，选择hook touchesEnded:withEvent:更合理。
- (void)prism_autoDot_touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    UITouch *touch = [touches anyObject];
    if (touch) {
        [params setObject:touch forKey:@"touch"];
    }
    [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIViewTouchesEnded_Start withSender:self params:[params copy]];
    
    //原始逻辑
    Method original_TouchesEnded = class_getInstanceMethod([UIView class], @selector(prism_autoDot_touchesEnded:withEvent:));
    IMP original_TouchesEnded_Method_Imp =  method_getImplementation(original_TouchesEnded);
    void (*functionPointer)(id, SEL, NSSet<UITouch *> *, UIEvent *) = (void (*)(id, SEL, NSSet<UITouch *> *, UIEvent *))original_TouchesEnded_Method_Imp;
    functionPointer(self, _cmd, touches, event);
    
    
    [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIViewTouchesEnded_End withSender:self params:[params copy]];
}
@end
