//
//  PrismInstructionInputUtil.m
//  DiDiPrism
//
//  Created by hulk on 2022/4/2.
//

#import "PrismInstructionInputUtil.h"

@interface PrismInstructionInputUtil()

@end

@implementation PrismInstructionInputUtil
#pragma mark - life cycle
+ (BOOL)isSystemKeyboardTouchEventWithModel:(PrismInstructionModel*)model {
    NSString *vp = model.vp;
    if ([vp hasPrefix:@"UIInputWindowController_&_UISystemInputAssistantViewController"] ||
        [vp hasPrefix:@"UIInputWindowController_&_UISystemKeyboardDockController"] ||
        [vp hasPrefix:@"UIInputWindowController_&_UICompatibilityInputViewController"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isSystemKeyboardOfViewController:(UIViewController*)viewController {
    return [viewController isKindOfClass:NSClassFromString(@"UICompatibilityInputViewController")] ||
    [viewController isKindOfClass:NSClassFromString(@"UISystemInputAssistantViewController")] ||
    [viewController isKindOfClass:NSClassFromString(@"UIPredictionViewController")] ||
    [viewController isKindOfClass:NSClassFromString(@"UIInputWindowController")] ||
    [viewController isKindOfClass:NSClassFromString(@"UISystemKeyboardDockController")];
}

#pragma mark - public method

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
