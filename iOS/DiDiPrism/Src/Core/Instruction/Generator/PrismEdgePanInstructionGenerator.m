//
//  PrismEdgePanInstructionGenerator.m
//  DiDiPrism
//
//  Created by hulk on 2020/9/24.
//

#import "PrismEdgePanInstructionGenerator.h"
#import "PrismInstructionDefines.h"
// Category
#import "UIResponder+PrismIntercept.h"
#import "UIView+PrismExtends.h"
// Util
#import "PrismInstructionResponseChainUtil.h"

@interface PrismEdgePanInstructionGenerator()

@end

@implementation PrismEdgePanInstructionGenerator
#pragma mark - life cycle

#pragma mark - public method
+ (NSString*)getInstructionOfEdgePanGesture:(UIScreenEdgePanGestureRecognizer*)edgePanGesture {
    UIView *view = edgePanGesture.view;
    if (!view) {
        return nil;
    }
    if (view.autoDotFinalMark.length) {
        return view.autoDotFinalMark;
    }
    
    NSString *responseChainInfo = [PrismInstructionResponseChainUtil getResponseChainInfoWithElement:view];
    // 获取响应链的方法本身有个问题，就是如果self.view为viewController.view的话，并不会统计到这个viewController。
    // 但是这一点对于后退滑动手势来说必须修复，所以先在这里修复。其他地方目前运行良好就不做改动（只是回放遍历的时候要多遍历一些）
    UIViewController *lastViewController = nil;
    UIResponder* nextResponder = [view nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        lastViewController = (UIViewController*)nextResponder;
    }
    view.autoDotFinalMark = [NSString stringWithFormat:@"%@%@%@%@", kBeginOfViewMotionFlag, kViewMotionEdgePanGestureFlag, responseChainInfo, lastViewController ? NSStringFromClass([lastViewController class]) : @""];
    return view.autoDotFinalMark;
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
