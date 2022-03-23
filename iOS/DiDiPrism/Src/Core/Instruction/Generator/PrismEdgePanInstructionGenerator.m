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
#import "PrismInstructionResponseChainInfoUtil.h"

@interface PrismEdgePanInstructionGenerator()

@end

@implementation PrismEdgePanInstructionGenerator
#pragma mark - life cycle

#pragma mark - public method
+ (PrismInstructionModel *)getInstructionModelOfEdgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePanGesture {
    UIView *view = edgePanGesture.view;
    if (!view) {
        return nil;
    }
    PrismInstructionModel *model = [[PrismInstructionModel alloc] init];
    model.vm = kViewMotionEdgePanGestureFlag;
    model.vp = [PrismInstructionResponseChainInfoUtil getResponseChainInfoWithElement:view];
    return model;
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
