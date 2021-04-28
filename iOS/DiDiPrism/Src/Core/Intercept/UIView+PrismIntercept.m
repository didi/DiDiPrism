//
//  UIView+PrismIntercept.m
//  DiDiPrism
//
//  Created by hulk on 2019/7/2.
//

#import "UIView+PrismIntercept.h"
// Dispatcher
#import "PrismEventDispatcher.h"
// Util
#import "PrismRuntimeUtil.h"

@implementation UIView (PrismIntercept)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(touchesEnded:withEvent:) swizzledSelector:@selector(autoDot_touchesEnded:withEvent:)];
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(didMoveToSuperview) swizzledSelector:@selector(autoDot_didMoveToSuperview)];
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(didMoveToWindow) swizzledSelector:@selector(autoDot_didMoveToWindow)];
    });
}

// 考虑到可能的手势影响，选择hook touchesEnded:withEvent:更合理。
- (void)autoDot_touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //原始逻辑
    Method original_TouchesEnded = class_getInstanceMethod([UIView class], @selector(autoDot_touchesEnded:withEvent:));
    IMP original_TouchesEnded_Method_Imp =  method_getImplementation(original_TouchesEnded);
    void (*functionPointer)(id, SEL, NSSet<UITouch *> *, UIEvent *) = (void (*)(id, SEL, NSSet<UITouch *> *, UIEvent *))original_TouchesEnded_Method_Imp;
    functionPointer(self, _cmd, touches, event);
    
    [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIViewTouchesEnded_End withSender:self params:nil];
}

- (void)autoDot_didMoveToSuperview {
    [self autoDot_didMoveToSuperview];
    if (!self.superview) {
        return;
    }
    [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIViewDidMoveToSuperview withSender:self params:nil];
}

- (void)autoDot_didMoveToWindow {
    [self autoDot_didMoveToWindow];
    if (!self.superview) {
        return;
    }
    [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIViewDidMoveToWindow withSender:self params:nil];
}
@end
