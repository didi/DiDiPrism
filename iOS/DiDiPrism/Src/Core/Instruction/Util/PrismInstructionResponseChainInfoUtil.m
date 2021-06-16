//
//  PrismInstructionResponseChainUtil.m
//  DiDiPrism
//
//  Created by hulk on 2019/6/27.
//

#import "PrismInstructionResponseChainInfoUtil.h"
// Category
#import "UIResponder+PrismIntercept.h"
#import "UIView+PrismExtends.h"

@implementation PrismInstructionResponseChainInfoUtil
#pragma mark - public method
+ (NSString*)getResponseChainInfoWithElement:(UIView*)element {
    if (!element || ![element superview]) {
        return nil;
    }
    NSMutableString *description = [NSMutableString string];
    NSArray<UIViewController*> *viewControllers = [self getParentViewControllersOfView:element];
    if (viewControllers.count) {
        [viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *mark = obj.autoDotSpecialMark.length ? obj.autoDotSpecialMark : NSStringFromClass([obj class]);
            [description appendFormat:@"%@_&_", mark];
        }];
    }
    else {
        NSArray<UIView*> *views = [self getParentViewOfView:element];
        if (views.count) {
            [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *mark = obj.autoDotSpecialMark.length ? obj.autoDotSpecialMark : NSStringFromClass([obj class]);
                [description appendFormat:@"%@_&_", mark];
            }];
        }
    }
    return [description copy];
}

#pragma mark - private method
+ (NSArray<UIViewController*>*)getParentViewControllersOfView:(UIView*)view {
    NSMutableArray<UIViewController*> *viewControllers = [NSMutableArray array];
    UIViewController *viewController = [view prism_viewController];
    if (viewController) {
        [viewControllers addObject:viewController];
        while (viewController.parentViewController) {
            viewController = viewController.parentViewController;
            [viewControllers insertObject:viewController atIndex:0];
        }
        //viewController.view被添加到了目标VC.view上，但是viewController没有被添加到目标VC上。
        if (viewController.view.superview.prism_viewController) {
            NSArray<UIViewController*> *moreVC = [self getParentViewControllersOfView:viewController.view.superview];
            if (moreVC.count) {
               [viewControllers insertObjects:moreVC atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,[moreVC count])]];
            }
        }
    }
    return [viewControllers copy];
}

+ (NSArray<UIView*>*)getParentViewOfView:(UIView*)view {
    NSMutableArray<UIView*> *views = [NSMutableArray array];
    [views addObject:view];
    while (view.superview) {
        view = view.superview;
        [views insertObject:view atIndex:0];
    }
    return [views copy];
}
@end
