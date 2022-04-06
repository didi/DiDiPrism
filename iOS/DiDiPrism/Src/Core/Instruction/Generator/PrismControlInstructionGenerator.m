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
#import "NSArray+PrismExtends.h"
// Util
#import "PrismInstructionResponseChainInfoUtil.h"
#import "PrismInstructionAreaInfoUtil.h"
#import "PrismInstructionContentUtil.h"
#import "PrismInstructionInputUtil.h"

@interface PrismControlInstructionGenerator()

@end

@implementation PrismControlInstructionGenerator
#pragma mark - life cycle

#pragma mark - public method
+ (PrismInstructionModel *)getInstructionModelOfControl:(UIControl *)control
                                  withTargetAndSelector:(NSString *)targetAndSelector
                                      withControlEvents:(NSString*)controlEvents {
    PrismInstructionModel *model = [[PrismInstructionModel alloc] init];
    model.vm = kViewMotionControlFlag;
    model.vp = [PrismInstructionResponseChainInfoUtil getResponseChainInfoWithElement:control];
    // 屏蔽键盘点击事件
    if ([PrismInstructionInputUtil isSystemKeyboardTouchEventWithModel:model]) {
        return nil;
    }
    NSArray *areaInfo = [PrismInstructionAreaInfoUtil getAreaInfoWithElement:control];
    model.vl = [areaInfo prism_stringWithIndex:0];
    model.vq = [areaInfo prism_stringWithIndex:1];
    model.vr = [self getViewContentOfControl:control];
    model.vf = [NSString stringWithFormat:@"%@%@%@", targetAndSelector ?: @"", kConnectorFlag, controlEvents ?: @""];
    return model;
}

+ (NSString*)getViewContentOfControl:(UIControl*)control {
    NSString *viewContent = @"";
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
    return viewContent;
}

#pragma mark - private method
+ (NSString*)getViewContentOfButton:(UIButton*)button {
    if (button.titleLabel.text.length) {
        return [NSString stringWithFormat:@"%@%@", kViewRepresentativeContentTypeText, button.titleLabel.text];
    }
    else if (button.titleLabel.attributedText.length) {
        return [NSString stringWithFormat:@"%@%@", kViewRepresentativeContentTypeText, button.titleLabel.attributedText.string];
    }
    else if (button.imageView.image) {
        return [NSString stringWithFormat:@"%@%@", kViewRepresentativeContentTypeLocalImage, button.imageView.image.prismAutoDotImageName];
    }
    return nil;
}

+ (NSString*)getViewContentOfSwitch:(UISwitch*)switchControl {
    if (switchControl.onImage.prismAutoDotImageName.length) {
        return [NSString stringWithFormat:@"%@%@", kViewRepresentativeContentTypeLocalImage, switchControl.onImage.prismAutoDotImageName];
    }
    else if (switchControl.offImage.prismAutoDotImageName.length) {
        return [NSString stringWithFormat:@"%@%@", kViewRepresentativeContentTypeLocalImage, switchControl.offImage.prismAutoDotImageName];
    }
    return nil;
}

+ (NSString*)getViewContentOfTextField:(UITextField*)textField {
    if (textField.placeholder.length) {
        return [NSString stringWithFormat:@"%@%@", kViewRepresentativeContentTypeText, textField.placeholder];
    }
    return nil;
}

#pragma mark - setters

#pragma mark - getters

@end
