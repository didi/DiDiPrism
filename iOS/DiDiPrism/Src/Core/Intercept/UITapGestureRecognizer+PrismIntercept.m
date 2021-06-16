//
//  UITapGestureRecognizer+PrismIntercept.m
//  DiDiPrism
//
//  Created by hulk on 2019/6/27.
//

#import "UITapGestureRecognizer+PrismIntercept.h"
// Dispatcher
#import "PrismEventDispatcher.h"
// Util
#import "PrismRuntimeUtil.h"
#import "PrismInstructionAreaUtil.h"
#import "PrismInstructionResponseChainUtil.h"
// Category
#import "UIResponder+PrismIntercept.h"

@implementation UITapGestureRecognizer (PrismIntercept)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(setState:) swizzledSelector:@selector(prism_autoDot_setState:)];
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(initWithTarget:action:) swizzledSelector:@selector(prism_autoDot_initWithTarget:action:)];
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(addTarget:action:) swizzledSelector:@selector(prism_autoDot_addTarget:action:)];
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(removeTarget:action:) swizzledSelector:@selector(prism_autoDot_removeTarget:action:)];
    });
}

- (void)prism_autoDot_setState:(UIGestureRecognizerState)state {
    [self prism_autoDot_setState:state];
    
    // set逻辑后 state 和 self.state 应一致，某些场景下self.state依然为UIGestureRecognizerStateFailed不符合预期。
    if (state == UIGestureRecognizerStateRecognized && self.state == UIGestureRecognizerStateRecognized) {
        //注1：没有选择在setState阶段直接进行event id的收集，是因为类似于WEEX场景中一次操作可以识别到多个手势（区别于实际起作用的手势）。
        //注2：选择在setState阶段先收集响应链信息和区位信息，是因为有些场景下点击事件触发后view.superview可能为nil，需提前捕捉。
        if ([self.view superview]) {
            NSString *responseChainInfo = [PrismInstructionResponseChainUtil getResponseChainInfoWithElement:self.view];
            if (responseChainInfo.length) {
                [self setAutoDotResponseChainInfo:responseChainInfo];
            }
            NSString *areaInfo = [PrismInstructionAreaUtil getAreaInfoWithElement:self.view];
            if (areaInfo.length) {
                [self setAutoDotAreaInfo:areaInfo];
            }
        }
    }
}


- (instancetype)prism_autoDot_initWithTarget:(id)target action:(SEL)action {
    //原始逻辑
    UITapGestureRecognizer *gesture = [self prism_autoDot_initWithTarget:target action:action];
    
    [gesture addTarget:self action:@selector(prism_autoDot_tapAction:)];
    gesture.autoDotTargetAndSelector = [NSString stringWithFormat:@"%@_&_%@", NSStringFromClass([target class]), NSStringFromSelector(action)];
    
    return gesture;
}

- (void)prism_autoDot_addTarget:(id)target action:(SEL)action {
    //原始逻辑
    [self prism_autoDot_addTarget:target action:action];
    
    [self prism_autoDot_addTarget:self action:@selector(prism_autoDot_tapAction:)];
    if (!self.autoDotTargetAndSelector.length) {
        self.autoDotTargetAndSelector = [NSString stringWithFormat:@"%@_&_%@", NSStringFromClass([target class]), NSStringFromSelector(action)];
    }
}

- (void)prism_autoDot_removeTarget:(id)target action:(SEL)action {
    //原始逻辑
    [self prism_autoDot_removeTarget:target action:action];
    
    [self prism_autoDot_removeTarget:self action:@selector(prism_autoDot_tapAction:)];
    self.autoDotTargetAndSelector = @"";
}

#pragma mark - actions
- (void)prism_autoDot_tapAction:(UITapGestureRecognizer*)tapGestureRecognizer {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"target"] = self;
    params[@"action"] = NSStringFromSelector(@selector(prism_autoDot_tapAction:));
    [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUITapGestureRecognizerAction withSender:self params:[params copy]];
}

#pragma mark - public method

#pragma mark - private method

#pragma mark - property
- (NSString *)autoDotTargetAndSelector {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setAutoDotTargetAndSelector:(NSString *)autoDotTargetAndSelector {
    objc_setAssociatedObject(self, @selector(autoDotTargetAndSelector), autoDotTargetAndSelector, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)autoDotResponseChainInfo {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setAutoDotResponseChainInfo:(NSString *)autoDotResponseChainInfo {
    objc_setAssociatedObject(self, @selector(autoDotResponseChainInfo), autoDotResponseChainInfo, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)autoDotAreaInfo {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setAutoDotAreaInfo:(NSString *)autoDotAreaInfo {
    objc_setAssociatedObject(self, @selector(autoDotAreaInfo), autoDotAreaInfo, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
