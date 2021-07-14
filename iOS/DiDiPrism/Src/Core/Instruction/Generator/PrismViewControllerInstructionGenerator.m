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
    if ([self isSystemKeyboardOfViewController:viewController]) {
        return nil;
    }
    NSString *viewContent = [self getViewContentOfViewController:viewController];
    return [NSString stringWithFormat:@"%@%@%@", kUIViewControllerDidAppear, kBeginOfViewRepresentativeContentFlag, viewContent ?: @""];
}

+ (PrismInstructionModel *)getInstructionModelOfViewController:(UIViewController *)viewController {
    if ([self isSystemKeyboardOfViewController:viewController]) {
        return nil;
    }
    PrismInstructionModel *model = [[PrismInstructionModel alloc] init];
    model.e = kUIViewControllerDidAppear;
    model.vr = [self getViewContentOfViewController:viewController];
    return model;
}

#pragma mark - private method
+ (BOOL)isSystemKeyboardOfViewController:(UIViewController*)viewController {
    return [viewController isKindOfClass:NSClassFromString(@"UICompatibilityInputViewController")] ||
    [viewController isKindOfClass:NSClassFromString(@"UISystemInputAssistantViewController")] ||
    [viewController isKindOfClass:NSClassFromString(@"UIPredictionViewController")] ||
    [viewController isKindOfClass:NSClassFromString(@"UIInputWindowController")] ||
    [viewController isKindOfClass:NSClassFromString(@"UISystemKeyboardDockController")];
}

+ (NSString*)getViewContentOfViewController:(UIViewController*)viewController {
    NSMutableString *vrContent = [NSMutableString stringWithString:NSStringFromClass([viewController class])];
    NSString *url = nil;
    if ([viewController respondsToSelector:@selector(getUrl)]) {
        url = [viewController performSelector:@selector(getUrl)];;
        if ([url isKindOfClass:[NSString class]] && url.length) {
            [vrContent appendFormat:@"%@%@", kConnectorFlag, url];
        }
    }
    else if ([viewController respondsToSelector:@selector(url)]) {
        url = [viewController performSelector:@selector(url)];;
        if ([url isKindOfClass:[NSString class]] && url.length) {
            [vrContent appendFormat:@"%@%@", kConnectorFlag, url];
        }
    }
    
    if (!url.length && [viewController title].length) {
        [vrContent appendFormat:@"%@%@", kConnectorFlag, [viewController title]];
    }
    else if (!url.length && [[[viewController navigationController] navigationItem] title].length) {
        [vrContent appendFormat:@"%@%@", kConnectorFlag, [[[viewController navigationController] navigationItem] title]];
    }
    
    return [vrContent copy];
}

#pragma mark - setters

#pragma mark - getters

@end
