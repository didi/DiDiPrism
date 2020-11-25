//
//  UIView+PrismExtends.m
//  DiDiPrism
//
//  Created by hulk on 2020/9/23.
//
//

#import "UIView+PrismExtends.h"

@implementation UIView (PrismExtends)
#pragma mark - public method
- (UITableView*)prism_UITableViewBelow {
    UIView *touchView = self;
    do {
        if ([touchView isKindOfClass:[UITableView class]]) {
            return (UITableView*)touchView;
        }
        touchView = (UIView*)touchView.nextResponder;
    } while (touchView && [touchView isKindOfClass:[UIView class]]);
    return nil;
}

- (UICollectionView*)prism_UICollectionViewBelow {
    UIView *touchView = self;
    do {
        if ([touchView isKindOfClass:[UICollectionView class]]) {
            return (UICollectionView*)touchView;
        }
        touchView = (UIView*)touchView.nextResponder;
    } while (touchView && [touchView isKindOfClass:[UIView class]]);
    return nil;
}

- (UIViewController *)prism_viewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (id)prism_wxComponent {
    SEL selector = NSSelectorFromString(@"wx_component");
    id wxComponent = [self respondsToSelector:selector] ? [self performSelector:selector] : nil;
    return wxComponent;
}

@end
