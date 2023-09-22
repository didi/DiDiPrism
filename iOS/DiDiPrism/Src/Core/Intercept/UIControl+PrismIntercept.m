//
//  UIControl+PrismIntercept.m
//  DiDiPrism
//
//  Created by hulk on 2019/6/27.
//

#import "UIControl+PrismIntercept.h"
#import <objc/runtime.h>
#import <RSSwizzle/RSSwizzle.h>
// Dispatcher
#import "PrismEventDispatcher.h"
// Category
#import "NSDictionary+PrismExtends.h"

@implementation UIControl (PrismIntercept)

#pragma mark - public method
+ (void)prism_swizzleMethodIMP {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Swizzle sendAction:to:forEvent:
        RSSwizzleInstanceMethod(UIControl, @selector(sendAction:to:forEvent:),
                                RSSWReturnType(void),
                                RSSWArguments(SEL action, id target, UIEvent *event),
                                RSSWReplacement({
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"target"] = target;
            params[@"action"] = NSStringFromSelector(action);
            [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIControlSendAction_Start withSender:self params:[params copy]];
            
            RSSWCallOriginal(action, target, event);
        }),
                                RSSwizzleModeAlways,
                                NULL);
        
        // Swizzle addTarget:action:forControlEvents:
        RSSwizzleInstanceMethod(UIControl, @selector(addTarget:action:forControlEvents:),
                                RSSWReturnType(void),
                                RSSWArguments(id target, SEL action, UIControlEvents controlEvents),
                                RSSWReplacement({
            RSSWCallOriginal(target, action, controlEvents);
            
            SEL swizzleSelector = NSSelectorFromString(@"prism_autoDot_addTarget:action:forControlEvents:");
            Method swizzleMethod = class_getInstanceMethod([UIControl class], swizzleSelector);
            IMP swizzleMethodImp =  method_getImplementation(swizzleMethod);
            void (*functionPointer)(id, SEL, id, SEL, UIControlEvents) = (void (*)(id, SEL, id, SEL, UIControlEvents))swizzleMethodImp;
            functionPointer(self, _cmd, target, action, controlEvents);
            
            RSSWCallOriginal(self, [self prism_autoDot_selectorForControlEvents:controlEvents], controlEvents);
        }),
                                RSSwizzleModeAlways,
                                NULL);
        
        // Swizzle removeTarget:action:forControlEvents:
        RSSwizzleInstanceMethod(UIControl, @selector(removeTarget:action:forControlEvents:),
                                RSSWReturnType(void),
                                RSSWArguments(id target, SEL action, UIControlEvents controlEvents),
                                RSSWReplacement({
            RSSWCallOriginal(target, action, controlEvents);
            
            SEL swizzleSelector = NSSelectorFromString(@"prism_autoDot_removeTarget:action:forControlEvents:");
            Method swizzleMethod = class_getInstanceMethod([UIControl class], swizzleSelector);
            IMP swizzleMethodImp =  method_getImplementation(swizzleMethod);
            void (*functionPointer)(id, SEL, id, SEL, UIControlEvents) = (void (*)(id, SEL, id, SEL, UIControlEvents))swizzleMethodImp;
            functionPointer(self, _cmd, target, action, controlEvents);
            
            RSSWCallOriginal(self, [self prism_autoDot_selectorForControlEvents:controlEvents], controlEvents);
        }),
                                RSSwizzleModeAlways,
                                NULL);
    });
}

#pragma mark - private method
- (void)prism_autoDot_addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
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
}

- (void)prism_autoDot_removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    NSString *controlEventsStr = [NSString stringWithFormat:@"%ld", controlEvents];
    self.prismAutoDotTargetAndSelector[controlEventsStr] = @"";
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
- (void)prism_autoDot_touchDownAction:(UIControl*)control {
    [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIControlTouchDownAction withSender:self params:nil];
}

- (void)prism_autoDot_touchUpInsideAction:(UIControl*)control {
    [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIControlTouchUpInsideAction withSender:self params:nil];
}

- (void)prism_autoDot_touchUpOutsideAction:(UIControl*)control {
    [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIControlTouchUpOutsideAction withSender:self params:nil];
}

- (void)prism_autoDot_otherTouchAction:(UIControl*)control {
    [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIControlOtherAction withSender:self params:nil];
}

#pragma mark - private method
- (SEL)prism_autoDot_selectorForControlEvents:(UIControlEvents)controlEvents {
    switch (controlEvents) {
        case UIControlEventTouchDown:
            return @selector(prism_autoDot_touchDownAction:);
            break;
        case UIControlEventTouchUpInside:
            return @selector(prism_autoDot_touchUpInsideAction:);
            break;
        case UIControlEventTouchUpOutside:
            return @selector(prism_autoDot_touchUpOutsideAction:);
            break;
        default:
            return @selector(prism_autoDot_otherTouchAction:);
            break;
    }
}

@end
