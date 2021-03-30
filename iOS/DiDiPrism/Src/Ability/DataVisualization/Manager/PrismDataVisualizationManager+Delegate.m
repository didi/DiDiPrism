//
//  PrismDataVisualizationManager+Delegate.m
//  DiDiPrism
//
//  Created by hulk on 2021/3/30.
//

#import "PrismDataVisualizationManager+Delegate.h"
// View
#import "PrismDataFloatingView.h"
// Component
#import "PrismDataFloatingMenuComponent.h"
#import "PrismDataFloatingComponent.h"

@implementation PrismDataVisualizationManager (Delegate)
#pragma mark - delegate
#pragma mark PrismDataFloatingMenuComponentDelegate
- (UIView*)matchViewWithTapGesture:(UITapGestureRecognizer*)tapGesture {
    UIWindow *mainWindow = UIApplication.sharedApplication.delegate.window;
    __block PrismDataFloatingComponent *floatingComponent = nil;
    [self.allComponents enumerateObjectsUsingBlock:^(PrismDataBaseComponent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PrismDataFloatingComponent class]]) {
            floatingComponent = obj;
            *stop = YES;
        }
    }];
    if (!floatingComponent) {
        return nil;
    }
    NSArray *allFloatingViews = [floatingComponent allFloatingViews];
    NSMutableArray<PrismDataFloatingView*> *allMatchedView = [NSMutableArray array];
    for (PrismDataFloatingView *floatingView in allFloatingViews) {
        CGPoint floatingViewPoint = [tapGesture locationInView:floatingView];
        if ([floatingView window]
            && [floatingView pointInside:floatingViewPoint withEvent:nil]) {
            [allMatchedView addObject:floatingView];
        }
    }
    UIView *hitTestView = [mainWindow hitTest:[tapGesture locationInView:mainWindow] withEvent:nil];
    PrismDataFloatingView *resultView = nil;
    while (!resultView && hitTestView) {
        for (PrismDataFloatingView *floatingView in allMatchedView) {
            if ([floatingView isDescendantOfView:hitTestView]) {
                resultView = floatingView;
                break;
            }
        }
        hitTestView = [hitTestView superview];
    }
    return resultView;
}

@end
