//
//  UIControl+PrismIntercept.m
//  DiDiPrism
//
//  Created by hulk on 2019/6/27.
//

#import "UIControl+PrismIntercept.h"
#import "PrismBehaviorRecordManager.h"
#import "PrismControlInstructionGenerator.h"
// Util
#import "PrismRuntimeUtil.h"
#import "PrismInstructionParamUtil.h"

@implementation UIControl (PrismIntercept)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(sendAction:to:forEvent:) swizzledSelector:@selector(autoDot_sendAction:to:forEvent:)];

        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(addTarget:action:forControlEvents:) swizzledSelector:@selector(autoDot_addTarget:action:forControlEvents:)];
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(removeTarget:action:forControlEvents:) swizzledSelector:@selector(autoDot_removeTarget:action:forControlEvents:)];
    });
}


- (void)autoDot_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if ([[PrismBehaviorRecordManager sharedManager] canUpload]) {
        NSString *targetAndSelector = [NSString stringWithFormat:@"%@_&_%@", NSStringFromClass([target class]), NSStringFromSelector(action)];
        if ([targetAndSelector isEqualToString:self.autoDotTargetAndSelector]) {
            NSString *instruction = [PrismControlInstructionGenerator getInstructionOfControl:self];
            if (instruction.length) {
                NSDictionary *eventParams = [PrismInstructionParamUtil getEventParamsWithElement:self];
                [[PrismBehaviorRecordManager sharedManager] addInstruction:instruction withEventParams:eventParams];
            }
        }
    }
    
    //原始逻辑
    [self autoDot_sendAction:action to:target forEvent:event];
}


- (void)autoDot_addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    //原始逻辑
    [self autoDot_addTarget:target action:action forControlEvents:controlEvents];
    
    // 忽略用户输入过程
    BOOL isEditingChangedEvent = controlEvents == UIControlEventEditingChanged;
    if (!isEditingChangedEvent && !self.autoDotTargetAndSelector.length) {
        NSString *classString = NSStringFromClass([target class]);
        NSString *actionString = NSStringFromSelector(action);
        if (classString.length && actionString.length) {
            self.autoDotTargetAndSelector = [NSString stringWithFormat:@"%@_&_%@", classString, actionString];
            
        }
    }
}

- (void)autoDot_removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    //原始逻辑
    [self autoDot_removeTarget:target action:action forControlEvents:controlEvents];
    
    self.autoDotTargetAndSelector = @"";
}

#pragma mark - actions

#pragma mark - public method

#pragma mark - private method

#pragma mark - property
- (NSString *)autoDotTargetAndSelector {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setAutoDotTargetAndSelector:(NSString *)autoDotTargetAndSelector {
    objc_setAssociatedObject(self, @selector(autoDotTargetAndSelector), autoDotTargetAndSelector, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
