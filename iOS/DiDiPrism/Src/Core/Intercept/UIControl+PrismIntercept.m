//
//  UIControl+PrismIntercept.m
//  DiDiPrism
//
//  Created by hulk on 2019/6/27.
//

#import "UIControl+PrismIntercept.h"
// Dispatcher
#import "PrismEventDispatcher.h"
// Util
#import "PrismRuntimeUtil.h"
// Category
#import "NSDictionary+PrismExtends.h"

@implementation UIControl (PrismIntercept)

#pragma mark - public method
+ (void)prism_swizzleMethodIMP {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(sendAction:to:forEvent:) swizzledSelector:@selector(prism_autoDot_sendAction:to:forEvent:)];
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(addTarget:action:forControlEvents:) swizzledSelector:@selector(prism_autoDot_addTarget:action:forControlEvents:)];
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(removeTarget:action:forControlEvents:) swizzledSelector:@selector(prism_autoDot_removeTarget:action:forControlEvents:)];
    });
}

#pragma mark - private method
- (void)prism_autoDot_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"target"] = target;
    params[@"action"] = NSStringFromSelector(action);
    [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIControlSendAction_Start withSender:self params:[params copy]];
    
    //原始逻辑
    [self prism_autoDot_sendAction:action to:target forEvent:event];
}

- (void)prism_autoDot_addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    //原始逻辑
    [self prism_autoDot_addTarget:target action:action forControlEvents:controlEvents];
    
    NSString *controlEventsStr = [NSString stringWithFormat:@"%ld", controlEvents];
    BOOL isTouchEvent = (controlEvents & UIControlEventAllTouchEvents) || (controlEvents & UIControlEventPrimaryActionTriggered);
    // 忽略用户输入过程
    BOOL isEditingEvent = (controlEvents & UIControlEventAllEditingEvents) && controlEvents != UIControlEventEditingChanged;
    BOOL isValueChangedEvent = controlEvents & UIControlEventValueChanged;
    BOOL isAllowedEvents = isTouchEvent || isEditingEvent || isValueChangedEvent;
    if (isAllowedEvents && ![[self.prismAutoDotTargetAndSelector prism_stringForKey:controlEventsStr] length]) {
        NSString *classString = NSStringFromClass([target class]);
        NSString *actionString = NSStringFromSelector(action);
        if (classString.length && actionString.length) {
            self.prismAutoDotTargetAndSelector[controlEventsStr] = [NSString stringWithFormat:@"%@_&_%@", classString, actionString];
        }
    }
    
    [self prism_autoDot_addTarget:self action:[self prism_autoDot_selectorForControlEvents:controlEvents] forControlEvents:controlEvents];
}

- (void)prism_autoDot_removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    //原始逻辑
    [self prism_autoDot_removeTarget:target action:action forControlEvents:controlEvents];
    
    NSString *controlEventsStr = [NSString stringWithFormat:@"%ld", controlEvents];
    self.prismAutoDotTargetAndSelector[controlEventsStr] = @"";
    
    [self prism_autoDot_removeTarget:self action:[self prism_autoDot_selectorForControlEvents:controlEvents] forControlEvents:controlEvents];
}

#pragma mark - property
- (NSMutableDictionary<NSString *,NSString *> *)prismAutoDotTargetAndSelector {
    NSMutableDictionary *result = objc_getAssociatedObject(self, _cmd);
    if (!result) {
        result = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, @selector(prismAutoDotTargetAndSelector), result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return result;
}
- (void)setPrismAutoDotTargetAndSelector:(NSMutableDictionary<NSString *,NSString *> *)prismAutoDotTargetAndSelector {
    objc_setAssociatedObject(self, @selector(prismAutoDotTargetAndSelector), prismAutoDotTargetAndSelector, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - actions
- (void)prism_autoDot_otherTouchAction:(UIControl*)control {
    [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIControlTouchAction withSender:self params:nil];
}

- (void)prism_autoDot_touchAction:(UIControl*)control {
    [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIControlTouchAction withSender:self params:nil];
}


#pragma mark - private method
- (SEL)prism_autoDot_selectorForControlEvents:(UIControlEvents)controlEvents {
    switch (controlEvents) {
        case UIControlEventTouchDown:
        case UIControlEventTouchDragInside:
        case UIControlEventTouchDragOutside:
        case UIControlEventTouchUpInside:
        case UIControlEventTouchUpOutside:
            return @selector(prism_autoDot_touchAction:);
            break;
        default:
            return @selector(prism_autoDot_otherTouchAction:);
            break;
    }
}

@end
