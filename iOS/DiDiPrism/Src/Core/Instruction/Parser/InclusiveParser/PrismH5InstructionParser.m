//
//  PrismH5InstructionParser.m
//  DiDiPrism
//
//  Created by hulk on 2020/4/17.
//

#import "PrismH5InstructionParser.h"
#import <WebKit/WebKit.h>

@interface PrismH5InstructionParser()

@end

@implementation PrismH5InstructionParser
#pragma mark - life cycle

#pragma mark - public method
- (NSObject *)parseWithFormatter:(PrismInstructionFormatter *)formatter {
    NSArray<NSString*> *h5ViewArray = [formatter instructionFragmentWithType:PrismInstructionFragmentTypeH5View];
    if (h5ViewArray.count < 2) {
        return nil;
    }
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *viewController = keyWindow.rootViewController;
    WKWebView *webView = (WKWebView*)[self recursiveSearchView:[WKWebView class] fromSuperView:viewController.view];
    if (!webView) {
        return nil;
    }
    if ([webView isLoading]) {
        return nil;
    }
    [webView evaluateJavaScript:[NSString stringWithFormat:@"PRISM_PLAYBACK_PLAY('%@')", h5ViewArray[1]] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];
    return webView;
}

#pragma mark - private method
- (UIView*)recursiveSearchView:(Class)viewClass fromSuperView:(UIView*)superView {
    if (!viewClass || !superView) {
        return nil;
    }
    if ([superView isKindOfClass:viewClass]) {
        return superView;
    }
    for (UIView *subview in [superView subviews]) {
        if (subview.isHidden) {
            continue;
        }
        if ([subview isKindOfClass:viewClass]) {
            return subview;
        }
        UIView *resultView = [self recursiveSearchView:viewClass fromSuperView:subview];
        if (resultView) {
            return resultView;
        }
    }
    return nil;
}

#pragma mark - setters

#pragma mark - getters

@end
