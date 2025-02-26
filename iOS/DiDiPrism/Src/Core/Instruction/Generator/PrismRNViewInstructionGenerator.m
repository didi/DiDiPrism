//
//  PrismRNViewInstructionGenerator.m
//  DiDiPrism
//
//  Created by hulk on 2025/2/8.
//

#import "PrismRNViewInstructionGenerator.h"
#import "PrismInstructionDefines.h"
// Util
#import "PrismInstructionResponseChainInfoUtil.h"
#import "PrismInstructionAreaInfoUtil.h"
#import "PrismInstructionContentUtil.h"
#import "PrismInstructionInputUtil.h"
// Category
#import "UIResponder+PrismIntercept.h"
#import "NSArray+PrismExtends.h"

@interface PrismRNViewInstructionGenerator()

@end

@implementation PrismRNViewInstructionGenerator
#pragma mark - life cycle

#pragma mark - public method
+ (PrismInstructionModel *)getInstructionModelOfView:(UIView *)view withPageInfo:(NSString*)pageInfo {
    PrismInstructionModel *model = [[PrismInstructionModel alloc] init];
    model.vm = kViewMotionRNViewFlag;
    model.vp = [PrismInstructionResponseChainInfoUtil getResponseChainInfoWithElement:view];
    if (pageInfo.length) {
        model.vp = [NSString stringWithFormat:@"%@%@%@", model.vp, kConnectorFlag, pageInfo];
    }
    // 屏蔽键盘点击事件
    if ([PrismInstructionInputUtil isSystemKeyboardTouchEventWithModel:model]) {
        return nil;
    }
    NSArray *areaInfo = [PrismInstructionAreaInfoUtil getAreaInfoWithElement:view];
    model.vl = [areaInfo prism_stringWithIndex:0];
    model.vq = [areaInfo prism_stringWithIndex:1];
    if (view.prismAutoDotContentCollectOff) {
        model.vr = kViewRepresentativeContentTypeHide;
    }
    else {
        model.vr = [PrismInstructionContentUtil getRepresentativeContentOfView:view needRecursive:YES];
    }
    return model;
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
