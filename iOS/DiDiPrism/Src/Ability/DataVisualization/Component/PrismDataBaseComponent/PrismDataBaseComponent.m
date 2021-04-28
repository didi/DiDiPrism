//
//  PrismDataBaseComponent.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import "PrismDataBaseComponent.h"

@interface PrismDataBaseComponent()

@end

@implementation PrismDataBaseComponent
#pragma mark - life cycle

#pragma mark - public method
- (void)dispatchEvent:(PrismDispatchEvent)event withSender:(NSObject *)sender params:(NSDictionary *)params {
    
}

#pragma mark - protected method
- (UIViewController*)_protected_searchMainViewController {
    UIViewController *mainViewController = nil;
    UIViewController *rootController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if ([rootController isKindOfClass:[UINavigationController class]]) {
        mainViewController = ((UINavigationController*)rootController).visibleViewController;
    }
    else {
        mainViewController = rootController.presentedViewController ? rootController.presentedViewController : rootController;
    }
    while (mainViewController.childViewControllers.count) {
        BOOL stop = YES;
        for (UIViewController *childVC in mainViewController.childViewControllers) {
            if ([childVC isViewLoaded]
                && childVC.view.window
                && [self isSimilarFrame:childVC.view.frame withParentFrame:mainViewController.view.bounds]) {
                stop = NO;
                mainViewController = childVC;
                break;
            }
        }
        if (stop) {
            break;
        }
    }
    return mainViewController;
}

#pragma mark - private method
- (BOOL)isSimilarFrame:(CGRect)childFrame withParentFrame:(CGRect)parentFrame {
    if (childFrame.origin.x == parentFrame.origin.x
        && childFrame.size.width == parentFrame.size.width
        && (fabs(childFrame.origin.y - parentFrame.origin.y) <= 10 || fabs(childFrame.origin.y + childFrame.size.height - parentFrame.origin.y - parentFrame.size.height) <= 10)
        && childFrame.size.height / parentFrame.size.height > 0.75) {
        return YES;
    }
    return NO;
}

#pragma mark - setters

#pragma mark - getters

@end
