//
//  PrismBehaviorTranslater.m
//  DiDiPrism
//
//  Created by hulk on 2020/9/27.
//

#import "PrismBehaviorTranslater.h"
#import <DiDiPrism/PrismInstructionAreaInfoUtil.h>
#import <DiDiPrism/NSString+PrismExtends.h>
#import <DiDiPrism/NSArray+PrismExtends.h>

static void(^retainCustomTranslater)(PrismBehaviorVideoModel*,PrismBehaviorTextModel*);

@interface PrismBehaviorTranslater()

@end

@implementation PrismBehaviorTranslater
#pragma mark - life cycle

#pragma mark - public method
+ (void)setCustomTranslater:(void (^)(PrismBehaviorVideoModel * _Nonnull, PrismBehaviorTextModel * _Nonnull))customTranslater {
    retainCustomTranslater = customTranslater;
}

+ (PrismBehaviorTextModel *)translateWithModel:(PrismBehaviorVideoModel *)model {
    NSArray<NSString*> *eventArray = [model.instructionFormatter instructionFragmentWithType:PrismInstructionFragmentTypeEvent];
    NSArray<NSString*> *h5ViewArray = [model.instructionFormatter instructionFragmentWithType:PrismInstructionFragmentTypeH5View];
    NSArray<NSString*> *viewMotionArray = [model.instructionFormatter instructionFragmentWithType:PrismInstructionFragmentTypeViewMotion];
    NSArray<NSString*> *viewRepresentativeContentArray = [model.instructionFormatter instructionFragmentWithType:PrismInstructionFragmentTypeViewRepresentativeContent];
    NSArray<NSString*> *viewFunctionArray = [model.instructionFormatter instructionFragmentWithType:PrismInstructionFragmentTypeViewFunction];
    NSArray<NSString*> *viewPathArray = [model.instructionFormatter instructionFragmentWithType:PrismInstructionFragmentTypeViewPath];
    NSArray<NSString*> *viewListArray = [model.instructionFormatter instructionFragmentWithType:PrismInstructionFragmentTypeViewList];
    NSInteger areaInfo = [model.instructionFormatter instructionFragmentContentWithType:PrismInstructionFragmentTypeViewQuadrant].integerValue;
    
    PrismBehaviorTextModel *textModel = [[PrismBehaviorTextModel alloc] init];
    textModel.operationName = [self getOperationNameWithInstruction:model.instruction withViewMotionType:[viewMotionArray prism_stringWithIndex:1] withViewFunctionArray:viewFunctionArray];
    textModel.areaInfo = areaInfo;
    textModel.areaText = [PrismInstructionAreaInfoUtil getAreaTextWithInfo:areaInfo];
    textModel.moduleText = [self getModuleTextWithViewListArray:viewListArray
                                              withViewPathArray:viewPathArray
                                          withViewFunctionArray:viewFunctionArray];
    textModel.elementName = [self getElementNameWithViewMotionType:[viewMotionArray prism_stringWithIndex:1]];
    textModel.descTime = (model.descTime.length && !eventArray.count) ? model.descTime : @"        ";
    NSArray *descInfo = [self getDescInfoWithInstruction:model.instruction
                                                     withEventArray:eventArray
                                                   withH5ViewArray:h5ViewArray
                                               withViewMotionArray:viewMotionArray
                                withViewRepresentativeContentArray:viewRepresentativeContentArray
                                                 withViewPathArray:viewPathArray
                                             withViewFunctionArray:viewFunctionArray];
    if (descInfo.count > 1) {
        textModel.descType = ((NSNumber*)[descInfo prism_objectAtIndex:0]).integerValue;
        textModel.descContent = [descInfo prism_stringWithIndex:1];
    }
    // 定制翻译逻辑
    if (retainCustomTranslater) {
        retainCustomTranslater(model,textModel);
    }
    return textModel;
}

#pragma mark - private method
+ (NSString*)getOperationNameWithInstruction:(NSString*)instruction
                          withViewMotionType:(NSString*)viewMotionType
                       withViewFunctionArray:(NSArray<NSString*> *)viewFunctionArray {
    NSString *operationName = @"点击";
    if ([viewMotionType isEqualToString:kViewMotionEdgePanGestureFlag]) {
        operationName = @"侧滑";
    }
    else if ([viewMotionType isEqualToString:kViewMotionLongPressGestureFlag]) {
        operationName = @"长按";
    }
    else if ([viewMotionType isEqualToString:kViewMotionTextFieldBFRFlag]) {
        operationName = @"开始输入";
    }
    else if ([viewMotionType isEqualToString:kViewMotionTextFieldRFRFlag]) {
        operationName = @"结束输入";
    }
    
    if ([instruction containsString:kUIApplicationJump]) {
        operationName = @"跳转";
    }
    else if ([instruction containsString:kUIApplicationOpenURL]) {
        operationName = @"APP调起";
    }
    else if ([instruction rangeOfString:kBeginOfEventFlag].length > 0 && [instruction rangeOfString:kBeginOfEventFlag].location == 0) {
        operationName = @"标记";
    }
    
    if ([operationName isEqualToString:@"点击"]) {
        if (viewFunctionArray.count > 3) {
            UIControlEvents events = [viewFunctionArray prism_stringWithIndex:3].integerValue;
            if (events == UIControlEventTouchDown) {
                operationName = @"点击按下";
            }
            else if (events == 1 << 13) {
                //UIControlEventPrimaryActionTriggered
                operationName = @"点击完成";
            }
        }
    }
    return operationName;
}

+ (NSString*)getElementNameWithViewMotionType:(NSString*)viewMotionType {
    NSString *elementName = nil;
    if ([viewMotionType isEqualToString:kViewMotionControlFlag]) {
        elementName = @"按钮";
    }
    else if ([viewMotionType isEqualToString:kViewMotionCellFlag]) {
        elementName = @"条目";
    }
    else if ([viewMotionType isEqualToString:kViewMotionTextFieldBFRFlag] || [viewMotionType isEqualToString:kViewMotionTextFieldRFRFlag]) {
        elementName = @"文本框";
    }
    return elementName;
}

+ (NSString*)getModuleTextWithViewListArray:(NSArray<NSString*> *)viewListArray
                          withViewPathArray:(NSArray<NSString*> *)viewPathArray
                      withViewFunctionArray:(NSArray<NSString*> *)viewFunctionArray {
    NSString *moduleText = nil;
    NSString *vp_1 = [viewPathArray prism_stringWithIndex:1];
    NSString *vf_1_lower = [[viewFunctionArray prism_stringWithIndex:1] lowercaseString];
    
    if ([vf_1_lower containsString:@"tabbar"]) {
        moduleText = @"导航栏";
    }
    else if ([self isWindowWith:vp_1]) {
        moduleText = @"悬浮窗";
    }
    return moduleText;
}

+ (NSArray*)getDescInfoWithInstruction:(NSString*)instruction
                        withEventArray:(NSArray<NSString*> *)eventArray
                       withH5ViewArray:(NSArray<NSString*> *)h5ViewArray
                   withViewMotionArray:(NSArray<NSString*> *)viewMotionArray
    withViewRepresentativeContentArray:(NSArray<NSString*> *)viewRepresentativeContentArray
                     withViewPathArray:(NSArray<NSString*> *)viewPathArray
                 withViewFunctionArray:(NSArray<NSString*> *)viewFunctionArray {
    __block PrismBehaviorDescType descType = PrismBehaviorDescTypeNone;
    __block NSString *descContent = @"";
    // 翻译通用事件
    if (eventArray.count) {
        descType = PrismBehaviorDescTypeText;
        NSString *description = [self descriptionOfEvent:instruction] ?: @"";
        NSMutableString *content = [NSMutableString stringWithString:description];
        if (viewRepresentativeContentArray.count > 0 && [viewRepresentativeContentArray[viewRepresentativeContentArray.count - 1] prism_trimmingWhitespaceAndNewlines].length > 0) {
            [content appendFormat:@" %@", viewRepresentativeContentArray[viewRepresentativeContentArray.count - 1]];
        }
        descContent = [content copy];
        return @[[NSNumber numberWithInteger:descType],descContent];
    }
    // 翻译H5指令
    if (h5ViewArray.count) {
        descType = PrismBehaviorDescTypeText;
        descContent = @"[H5页面]";
        if (viewRepresentativeContentArray.count > 1 && [viewRepresentativeContentArray[1] prism_trimmingWhitespaceAndNewlines].length > 0) {
            NSString *content = viewRepresentativeContentArray[1];
            if ([self hasNetworkImage:content]) {
                descType = PrismBehaviorDescTypeNetworkImage;
                descContent = content;
            }
            else {
                descContent = [NSString stringWithFormat:@"[H5页面] %@", [content stringByReplacingOccurrencesOfString:kViewRepresentativeContentTypeText withString:@""]];
            }
        }
        return @[[NSNumber numberWithInteger:descType],descContent];
    }
    // 翻译触发类型
    NSString *viewMotionType = [viewMotionArray prism_stringWithIndex:1];
    if ([viewMotionType isEqualToString:kViewMotionEdgePanGestureFlag]) {
        descType = PrismBehaviorDescTypeText;
        descContent = @"后退";
        return @[[NSNumber numberWithInteger:descType],descContent];
    }
    else if ([viewMotionType isEqualToString:kViewMotionTextFieldBFRFlag]) {
        descType = PrismBehaviorDescTypeText;
        descContent = [[viewFunctionArray prism_stringWithIndex:1] stringByReplacingOccurrencesOfString:kViewRepresentativeContentTypeText withString:@""] ?: @"";
        return @[[NSNumber numberWithInteger:descType],descContent];
    }
    else if ([viewMotionType isEqualToString:kViewMotionTextFieldRFRFlag]) {
        descType = PrismBehaviorDescTypeText;
        descContent = [NSString stringWithFormat:@"输入内容：%@", [[viewRepresentativeContentArray prism_stringWithIndex:1] stringByReplacingOccurrencesOfString:kViewRepresentativeContentTypeText withString:@""] ?: @""];
        return @[[NSNumber numberWithInteger:descType],descContent];
    }
    else {
        // 翻译参考信息
        NSArray<NSString*> *contentArray = [[NSArray array] arrayByAddingObjectsFromArray:viewRepresentativeContentArray];
        [contentArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj containsString:kViewRepresentativeContentTypeText]) {
                descType = PrismBehaviorDescTypeText;
                descContent = [obj stringByReplacingOccurrencesOfString:kViewRepresentativeContentTypeText withString:@""];
                *stop = YES;
            }
            else if ([obj containsString:kViewRepresentativeContentTypeLocalImage]) {
                descType = PrismBehaviorDescTypeLocalImage;
                descContent = [obj stringByReplacingOccurrencesOfString:kViewRepresentativeContentTypeLocalImage withString:@""];
                *stop = YES;
            }
            else if ([obj containsString:kViewRepresentativeContentTypeNetworkImage]) {
                descType = PrismBehaviorDescTypeNetworkImage;
                descContent = [obj stringByReplacingOccurrencesOfString:kViewRepresentativeContentTypeNetworkImage withString:@""];
                *stop = YES;
            }
        }];
    }
    
    if (descType != PrismBehaviorDescTypeNone) {
        return @[[NSNumber numberWithInteger:descType],descContent];
    }
    
    // 翻译功能信息
    if (viewFunctionArray.count) {
        descType = PrismBehaviorDescTypeCode;
        descContent = [viewFunctionArray prism_stringWithIndex:2];
    }
    return @[[NSNumber numberWithInteger:descType],descContent];
}

+ (BOOL)hasNetworkImage:(NSString *)str {
    if (([str containsString:@"http://"] || [str containsString:@"https://"])
        && ([str containsString:@".png"] || [str containsString:@".jpg"] || [str containsString:@".jpeg"])) {
        return YES;
    }
    return NO;
}

+ (BOOL)isWindowWith:(NSString*)str {
    if ([NSClassFromString(str) isSubclassOfClass:[UIWindow class]]) {
        return YES;
    }
    return NO;
}

+ (NSString*)descriptionOfEvent:(NSString*)event {
    if ([event isEqualToString:kUIApplicationInit]) {
        return @"APP启动";
    }
    else if ([event isEqualToString:kUIApplicationBecomeActive]) {
        return @"APP进入前台";
    }
    else if ([event isEqualToString:kUIApplicationResignActive]) {
        return @"APP切到后台";
    }
    else if ([event containsString:kUIViewControllerDidAppear]) {
        return @"进入页面";
    }
    return nil;
}

#pragma mark - setters

#pragma mark - getters

@end
