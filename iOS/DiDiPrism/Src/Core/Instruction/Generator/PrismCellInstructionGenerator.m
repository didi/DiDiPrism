//
//  PrismCellInstructionGenerator.m
//  DiDiPrism
//
//  Created by hulk on 2020/9/25.
//

#import "PrismCellInstructionGenerator.h"
#import "PrismInstructionDefines.h"
// Util
#import "PrismInstructionResponseChainUtil.h"
#import "PrismInstructionAreaUtil.h"
#import "PrismInstructionContentUtil.h"
// Category
#import "UIResponder+PrismIntercept.h"

@interface PrismCellInstructionGenerator()

@end

@implementation PrismCellInstructionGenerator
#pragma mark - life cycle

#pragma mark - public method
+ (NSString*)getInstructionOfCell:(UIView*)cell {
    NSString *responseChainInfo = [PrismInstructionResponseChainUtil getResponseChainInfoWithElement:cell];
    NSString *areaInfo = [PrismInstructionAreaUtil getAreaInfoWithElement:cell];
    NSString *viewContent = [PrismInstructionContentUtil getRepresentativeContentOfView:cell needRecursive:YES];
    cell.autoDotFinalMark = [NSString stringWithFormat:@"%@%@%@%@%@%@", kBeginOfViewMotionFlag, kViewMotionCellFlag, responseChainInfo, areaInfo, kBeginOfViewRepresentativeContentFlag, viewContent.length ? viewContent : @""];
    return cell.autoDotFinalMark;
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
