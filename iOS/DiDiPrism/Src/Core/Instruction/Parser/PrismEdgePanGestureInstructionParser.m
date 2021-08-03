//
//  PrismEdgePanGestureInstructionParser.m
//  DiDiPrism
//
//  Created by hulk on 2019/10/15.
//

#import "PrismEdgePanGestureInstructionParser.h"
// Category
#import "PrismBaseInstructionParser+Protected.h"
#import "NSArray+PrismExtends.h"
#import "UIView+PrismExtends.h"

@interface PrismEdgePanGestureInstructionParser()

@end

@implementation PrismEdgePanGestureInstructionParser
#pragma mark - life cycle

#pragma mark - public method
- (PrismInstructionParseResult)parseWithFormatter:(PrismInstructionFormatter *)formatter {
    // 解析响应链信息
    NSArray<NSString*> *viewPathArray = [formatter instructionFragmentWithType:PrismInstructionFragmentTypeViewPath];
    UIResponder *responder = [self searchRootResponderWithClassName:[viewPathArray prism_stringWithIndex:1]];
    if (!responder) {
        return PrismInstructionParseResultFail;
    }
    if (!viewPathArray.lastObject.length) {
        viewPathArray = [viewPathArray subarrayWithRange:NSMakeRange(0, viewPathArray.count - 1)];
    }
    
    NSArray<UIResponder*> *allPossibleResponder = [NSArray arrayWithObject:responder];
    NSInteger index = 2;
    for (; index < viewPathArray.count; index++) {
        Class class = NSClassFromString(viewPathArray[index]);
        if (!class) {
            break;
        }
        NSArray<UIResponder*> *result = [self searchRespondersWithClassName:viewPathArray[index] superResponders:allPossibleResponder];
        if (!result.count) {
            break;
        }
        allPossibleResponder = result;
    }
    if (index < viewPathArray.count) {
        return PrismInstructionParseResultError;
    }
    
    UIScreenEdgePanGestureRecognizer *edgePanGesture = nil;
    UIViewController *targetViewController = nil;
    
    for (UIResponder *possibleResponder in allPossibleResponder) {
        
        if ([possibleResponder isKindOfClass:[UIView class]]) {
            UIView *view = (UIView*)possibleResponder;
            targetViewController = [view prism_viewController];
        }
        else {
            targetViewController = (UIViewController*)possibleResponder;
        }
        UIView *targetView = targetViewController.view;
        edgePanGesture = [self searchEdgePanGestureFromSuperView:targetView];
        
        if (edgePanGesture) {
            break;
        }
    }
    
    if (edgePanGesture) {
        if ([targetViewController isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController*)targetViewController popViewControllerAnimated:YES];
        }
        else if (targetViewController.navigationController) {
            [targetViewController.navigationController popViewControllerAnimated:YES];
        }
        else if (targetViewController.parentViewController.presentingViewController) {
            [targetViewController.parentViewController dismissViewControllerAnimated:YES completion:nil];
        }
        return PrismInstructionParseResultSuccess;
    }
    return PrismInstructionParseResultFail;
}

#pragma mark - private method
- (UIScreenEdgePanGestureRecognizer*)searchEdgePanGestureFromSuperView:(UIView*)superView {
    for (UIGestureRecognizer *gesture in superView.gestureRecognizers) {
        if ([gesture isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
            UIScreenEdgePanGestureRecognizer *edgePanGesture = (UIScreenEdgePanGestureRecognizer*)gesture;
           
            if (edgePanGesture.edges == UIRectEdgeLeft) {
                return edgePanGesture;
            }
        }
    }
    for (UIView *subview in superView.subviews) {
        UIScreenEdgePanGestureRecognizer *edgePanGesture = [self searchEdgePanGestureFromSuperView:subview];
        if (edgePanGesture) {
            return edgePanGesture;
        }
    }
    return nil;
}

#pragma mark - setters

#pragma mark - getters

@end
