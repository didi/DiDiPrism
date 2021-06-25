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
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(sendAction:to:forEvent:) swizzledSelector:@selector(prism_autoDot_sendAction:to:forEvent:)];
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(addTarget:action:forControlEvents:) swizzledSelector:@selector(prism_autoDot_addTarget:action:forControlEvents:)];
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(removeTarget:action:forControlEvents:) swizzledSelector:@selector(prism_autoDot_removeTarget:action:forControlEvents:)];
    });
}

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
    
    NSString *controlEventsStr = [NSString stringWithFormat:@"UIControlEvents-%ld", controlEvents];
    // 忽略用户输入过程
    BOOL isEditingChangedEvent = controlEvents == UIControlEventEditingChanged;
    if (!isEditingChangedEvent && ![[self.prismAutoDotTargetAndSelector prism_stringForKey:controlEventsStr] length]) {
        NSString *classString = NSStringFromClass([target class]);
        NSString *actionString = NSStringFromSelector(action);
        if (classString.length && actionString.length) {
            self.prismAutoDotTargetAndSelector[controlEventsStr] = [NSString stringWithFormat:@"%@_&_%@", classString, actionString];
        }
    }
}

- (void)prism_autoDot_removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    //原始逻辑
    [self prism_autoDot_removeTarget:target action:action forControlEvents:controlEvents];
    
    NSString *controlEventsStr = [NSString stringWithFormat:@"UIControlEvents-%ld", controlEvents];
    self.prismAutoDotTargetAndSelector[controlEventsStr] = @"";
}

#pragma mark - actions

#pragma mark - public method

#pragma mark - private method

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
@end
