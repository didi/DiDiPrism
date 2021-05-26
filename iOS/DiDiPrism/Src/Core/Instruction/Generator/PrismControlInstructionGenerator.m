//
//  PrismControlInstructionGenerator.m
//  DiDiPrism
//
//  Created by hulk on 2020/9/23.
//

#import "PrismControlInstructionGenerator.h"
#import "PrismInstructionDefines.h"
// Category
#import "UIControl+PrismIntercept.h"
#import "UIImage+PrismIntercept.h"
#import "UIResponder+PrismIntercept.h"
// Util
#import "PrismInstructionResponseChainUtil.h"
#import "PrismInstructionAreaUtil.h"
#import "PrismInstructionContentUtil.h"

@interface PrismControlInstructionGenerator()

@end

@implementation PrismControlInstructionGenerator
#pragma mark - life cycle

#pragma mark - public method
+ (NSString*)getInstructionOfControl:(UIControl*)control {
    // 避免重复生成，但会出现被复用控件标识不变的问题。
    if (control.autoDotFinalMark.length) {
        return control.autoDotFinalMark;
    }
    NSString *responseChainInfo = [PrismInstructionResponseChainUtil getResponseChainInfoWithElement:control];
    NSString *areaInfo = [PrismInstructionAreaUtil getAreaInfoWithElement:control];
    NSString *viewContent = [self getViewContentOfControl:control];
    NSString *functionName = [self getFunctionNameOfControl:control];
    NSString *instruction = [NSString stringWithFormat:@"%@%@%@%@%@%@", kBeginOfViewMotionFlag, kViewMotionControlFlag, responseChainInfo, areaInfo, viewContent, functionName];
    // 注：列表中的cell存在复用机制，cell复用时指令不可复用。
    if ([areaInfo containsString:kBeginOfViewListFlag]) {
        return instruction;
    }
    else {
        control.autoDotFinalMark = instruction;
        return control.autoDotFinalMark;
    }
}

+ (NSString*)getViewContentOfControl:(UIControl*)control {
    NSString *viewContent = nil;
    if ([control isKindOfClass:[UIButton class]]) {
        viewContent = [self getViewContentOfButton:(UIButton *)control];
    }
    else if ([control isKindOfClass:[UISwitch class]]) {
        viewContent = [self getViewContentOfSwitch:(UISwitch *)control];
    }
    else if ([control isKindOfClass:[UITextField class]]) {
        viewContent = [self getViewContentOfTextField:(UITextField *)control];
    }
    if (!viewContent.length) {
        // 获取有代表性的内容便于更好的定位view
        viewContent = [PrismInstructionContentUtil getRepresentativeContentOfView:control needRecursive:YES];
    }
    if (viewContent.length) {
        return [NSString stringWithFormat:@"%@%@", kBeginOfViewRepresentativeContentFlag, viewContent];
    }
    return @"";
}

+ (NSString*)getFunctionNameOfControl:(UIControl*)control {
    if (control.autoDotTargetAndSelector.length) {
        return [NSString stringWithFormat:@"%@%@", kBeginOfViewFunctionFlag, control.autoDotTargetAndSelector];
    }
    return @"";
}

#pragma mark - private method
+ (NSString*)getViewContentOfButton:(UIButton*)button {
    if (button.titleLabel.text.length) {
        return button.titleLabel.text;
    }
    else if (button.titleLabel.attributedText.length) {
        return button.titleLabel.attributedText.string;
    }
    else if (button.imageView.image) {
        return button.imageView.image.autoDotImageName;
    }
    return nil;
}

+ (NSString*)getViewContentOfSwitch:(UISwitch*)switchControl {
    if (switchControl.onImage.autoDotImageName.length) {
        return switchControl.onImage.autoDotImageName;
    }
    else if (switchControl.offImage.autoDotImageName.length) {
        return switchControl.offImage.autoDotImageName;
    }
    return nil;
}

+ (NSString*)getViewContentOfTextField:(UITextField*)textField {
    if (textField.placeholder.length) {
        return textField.placeholder;
    }
    return nil;
}

#pragma mark - setters

#pragma mark - getters

@end
