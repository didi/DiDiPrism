//
//  PrismViewControllerInstructionGenerator.m
//  DiDiPrism
//
//  Created by hulk on 2020/9/25.
//

#import "PrismViewControllerInstructionGenerator.h"
#import "PrismInstructionDefines.h"

@interface PrismViewControllerInstructionGenerator()

@end

@implementation PrismViewControllerInstructionGenerator
#pragma mark - life cycle

#pragma mark - public method
+ (NSString*)getInstructionOfViewController:(UIViewController*)viewController {
    NSMutableString *vrContent = [NSMutableString stringWithString:NSStringFromClass([viewController class])];
    NSString *url = nil;
    SEL urlSelector = @selector(getUrl);
    if ([viewController respondsToSelector:urlSelector]) {
        url = [viewController performSelector:urlSelector];;
        if ([url isKindOfClass:[NSString class]] && url.length) {
            [vrContent appendFormat:@"%@%@", kConnectorFlag, url];
        }
    }
    if (!url && [self isSystemKeyboardOfViewController:viewController]) {
        [vrContent appendFormat:@"%@%@", kConnectorFlag, @"系统键盘"];
    }
    else if (!url && [viewController title].length) {
        [vrContent appendFormat:@"%@%@", kConnectorFlag, [viewController title]];
    }
    else {
        [vrContent appendFormat:@"%@%@", kConnectorFlag, NSStringFromClass([viewController class])];
    }
    return [NSString stringWithFormat:@"%@%@%@", kUIViewControllerDidAppear, kBeginOfViewRepresentativeContentFlag, [vrContent copy]];
}

#pragma mark - private method
+ (BOOL)isSystemKeyboardOfViewController:(UIViewController*)viewController {
    return [viewController isKindOfClass:NSClassFromString(@"UICompatibilityInputViewController")] ||
    [viewController isKindOfClass:NSClassFromString(@"UISystemInputAssistantViewController")] ||
    [viewController isKindOfClass:NSClassFromString(@"UIPredictionViewController")] ||
    [viewController isKindOfClass:NSClassFromString(@"UIInputWindowController")] ||
    [viewController isKindOfClass:NSClassFromString(@"UISystemKeyboardDockController")];
}

#pragma mark - setters

#pragma mark - getters

@end
