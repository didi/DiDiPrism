//
//  PrismDataVisualizationManager+Delegate.m
//  DiDiPrism
//
//  Created by hulk on 2021/3/30.
//

#import "PrismDataVisualizationManager+Delegate.h"

@implementation PrismDataVisualizationManager (Delegate)
#pragma mark - delegate
#pragma mark PrismDataFloatingMenuComponentDelegate
- (UIView*)matchViewWithTapGesture:(UITapGestureRecognizer*)tapGesture {
    UIWindow *mainWindow = UIApplication.sharedApplication.delegate.window;
    PrismDataFloatingComponent *floatingComponent = [self floatingComponent];
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

#pragma mark PrismDataSwitchComponentDelegate
- (void)switchToMode:(PrismDataSwitchComponentMode)mode {
    PrismDataFloatingComponent *floatingComponent = [self floatingComponent];
    if (!floatingComponent) {
        return;
    }
    BOOL isHeatMode = mode == PrismDataSwitchComponentHeatMode;
    NSArray<PrismDataFloatingView*> *allFloatingViews = [floatingComponent allFloatingViews];
    for (PrismDataFloatingView *view in allFloatingViews) {
        [view setHeatMapEnable:isHeatMode];
    }
}

#pragma mark PrismDataFilterComponentDelegate
- (void)filterDataWithConfig:(NSArray<PrismDataFilterItemConfig *> *)config {
    [[self floatingComponent] reloadAllFloatingViewsWithFilterConfig:config];
}

- (void)foldAllComponent:(BOOL)isFolding {
    [[self switchComponent] handleView:isFolding];
}

#pragma mark - private method
- (PrismDataFloatingComponent*)floatingComponent {
    __block PrismDataFloatingComponent *floatingComponent = nil;
    [self.allComponents enumerateObjectsUsingBlock:^(PrismDataBaseComponent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PrismDataFloatingComponent class]]) {
            floatingComponent = obj;
            *stop = YES;
        }
    }];
    return floatingComponent;
}

- (PrismDataSwitchComponent*)switchComponent {
    __block PrismDataSwitchComponent *switchComponent = nil;
    [self.allComponents enumerateObjectsUsingBlock:^(PrismDataBaseComponent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PrismDataSwitchComponent class]]) {
            switchComponent = obj;
            *stop = YES;
        }
    }];
    return switchComponent;
}
@end
