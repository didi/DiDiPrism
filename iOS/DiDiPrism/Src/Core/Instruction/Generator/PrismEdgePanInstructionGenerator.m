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
    view.autoDotFinalMark = [NSString stringWithFormat:@"%@%@%@", kBeginOfViewMotionFlag, kViewMotionEdgePanGestureFlag, responseChainInfo];
    return view.autoDotFinalMark;
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
