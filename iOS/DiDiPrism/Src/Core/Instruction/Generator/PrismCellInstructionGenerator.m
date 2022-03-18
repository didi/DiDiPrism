//
//  PrismCellInstructionGenerator.m
//  DiDiPrism
//
//  Created by hulk on 2020/9/25.
//

#import "PrismCellInstructionGenerator.h"
#import "PrismInstructionDefines.h"
// Util
#import "PrismInstructionResponseChainInfoUtil.h"
#import "PrismInstructionAreaInfoUtil.h"
#import "PrismInstructionContentUtil.h"
// Category
#import "UIResponder+PrismIntercept.h"
#import "NSArray+PrismExtends.h"

@interface PrismCellInstructionGenerator()

@end

@implementation PrismCellInstructionGenerator
#pragma mark - life cycle

#pragma mark - public method
+ (PrismInstructionModel *)getInstructionModelOfCell:(UIView *)cell {
    return [self getInstructionModelOfCell:cell withMode:PrismInstructionModeInclusive];
}

+ (PrismInstructionModel *)getInstructionModelOfCell:(UIView *)cell withMode:(PrismInstructionMode)mode {
    if (mode == PrismInstructionModeInclusive) {
        PrismInstructionModel *model = [[PrismInstructionModel alloc] init];
        model.vm = kViewMotionCellFlag;
        model.vp = [PrismInstructionResponseChainInfoUtil getResponseChainInfoWithElement:cell];
        NSArray *areaInfo = [PrismInstructionAreaInfoUtil getAreaInfoWithElement:cell];
        model.vl = [areaInfo prism_stringWithIndex:0];
        model.vq = [areaInfo prism_stringWithIndex:1];
        model.vr = [PrismInstructionContentUtil getRepresentativeContentOfView:cell needRecursive:YES];
        return model;
    }
    else if (mode == PrismInstructionModeStrict) {
        PrismInstructionModel *model = [[PrismInstructionModel alloc] init];
        model.vm = kViewMotionCellFlag;
        model.vp = [PrismInstructionResponseChainInfoUtil getResponseChainInfoWithElement:cell];
        // TODO: 补齐vt
//        model.vt = 
        return model;
    }
    return nil;
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
