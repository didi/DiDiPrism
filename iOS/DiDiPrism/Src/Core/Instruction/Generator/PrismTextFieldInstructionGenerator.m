//
//  PrismTextFieldInstructionGenerator.m
//  DiDiPrism
//
//  Created by hulk on 2022/4/2.
//

#import "PrismTextFieldInstructionGenerator.h"
#import "PrismInstructionDefines.h"
// Category
#import "NSArray+PrismExtends.h"
// Util
#import "PrismInstructionResponseChainInfoUtil.h"
#import "PrismInstructionAreaInfoUtil.h"
#import "PrismInstructionContentUtil.h"

@interface PrismTextFieldInstructionGenerator()

@end

@implementation PrismTextFieldInstructionGenerator
#pragma mark - life cycle
+ (PrismInstructionModel *)getInstructionModelOfTextField:(UITextField *)textField withEvent:(PrismDispatchEvent)event {
    PrismInstructionModel *model = [[PrismInstructionModel alloc] init];
    if (event == PrismDispatchEventUITextFieldBecomeFirstResponder) {
        model.vm = kViewMotionTextFieldBFRFlag;
    }
    else if (event == PrismDispatchEventUITextFieldResignFirstResponder) {
        model.vm = kViewMotionTextFieldRFRFlag;
    }
    model.vp = [PrismInstructionResponseChainInfoUtil getResponseChainInfoWithElement:textField];
    NSArray *areaInfo = [PrismInstructionAreaInfoUtil getAreaInfoWithElement:textField];
    model.vl = [areaInfo prism_stringWithIndex:0];
    model.vq = [areaInfo prism_stringWithIndex:1];
    model.vr = textField.text.length ? [NSString stringWithFormat:@"%@%@", kViewRepresentativeContentTypeText, textField.text] : nil;
    model.vf = textField.placeholder.length ? [NSString stringWithFormat:@"%@%@", kViewRepresentativeContentTypeText, textField.placeholder] : nil;
    return model;
}

#pragma mark - public method

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
