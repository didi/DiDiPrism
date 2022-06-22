//
//  PrismTapGestureInstructionGenerator.m
//  DiDiPrism
//
//  Created by hulk on 2020/9/24.
//

#import "PrismTapGestureInstructionGenerator.h"
#import "PrismInstructionDefines.h"
// Util
#import "PrismInstructionResponseChainInfoUtil.h"
#import "PrismInstructionContentUtil.h"
#import "PrismInstructionInputUtil.h"
// Category
#import "UITapGestureRecognizer+PrismIntercept.h"
#import "UIResponder+PrismIntercept.h"
#import "UIImage+PrismIntercept.h"
#import "UIView+PrismExtends.h"
#import "NSArray+PrismExtends.h"
#import "UIGestureRecognizer+PrismExtends.h"

@interface PrismTapGestureInstructionGenerator()

@end

@implementation PrismTapGestureInstructionGenerator
#pragma mark - life cycle

#pragma mark - public method
+ (PrismInstructionModel *)getInstructionModelOfTapGesture:(UITapGestureRecognizer *)tapGesture {
    UIView *view = tapGesture.view;
    if (!view) {
        return nil;
    }
    PrismInstructionModel *model = [[PrismInstructionModel alloc] init];
    model.vm = kViewMotionTapGestureFlag;
    model.vp = [tapGesture prismAutoDotResponseChainInfo];
    // 屏蔽键盘点击事件
    if ([PrismInstructionInputUtil isSystemKeyboardTouchEventWithModel:model]) {
        return nil;
    }
    NSArray *areaInfo = [tapGesture prismAutoDotAreaInfo];
    model.vl = [areaInfo prism_stringWithIndex:0];
    model.vq = [areaInfo prism_stringWithIndex:1];
    // 屏蔽Native侧的H5页面点击指令
    if (([model.vl containsString:@"WKScrollView"] || [model.vl containsString:@"WKContentView"])) {
        return nil;
    }
    if (view.prismAutoDotContentCollectOff) {
        model.vr = kViewRepresentativeContentTypeHide;
    }
    else {
        model.vr = [PrismInstructionContentUtil getRepresentativeContentOfView:view needRecursive:YES];
    }
    model.vf = [self getFunctionNameOfTapGesture:tapGesture];
    return model;
}

+ (NSString*)getFunctionNameOfTapGesture:(UITapGestureRecognizer*)tapGesture {
    UIView *view = tapGesture.view;
    
    // WEEX
    id wxComponent = [view prism_wxComponent];
    if (wxComponent && [wxComponent isKindOfClass:NSClassFromString(@"WXComponent")]) {
        NSMutableString *functionName = [NSMutableString string];
        NSDictionary *wxAttributes = [wxComponent valueForKey:@"attributes"];
        NSString *wxFunctionName = [wxAttributes valueForKey:@"prismFunctionName"];
        NSString *wxClassName = [wxAttributes valueForKey:@"prismClassName"];
        if (([wxFunctionName isKindOfClass:[NSString class]] && wxFunctionName.length)
            || ([wxClassName isKindOfClass:[NSString class]] && wxClassName.length)) {
            if ([wxFunctionName isKindOfClass:[NSString class]] && wxFunctionName.length) {
                [functionName appendString:wxFunctionName];
            }
            if ([wxClassName isKindOfClass:[NSString class]] && wxClassName.length) {
                if (functionName.length) {
                    [functionName appendString:@"-"];
                }
                [functionName appendString:wxClassName];
            }
        }
        if (functionName.length) {
            return [NSString stringWithFormat:@"%@_&_%@", functionName, tapGesture.prismAutoDotTargetAndSelector];
        }
    }
    
    return tapGesture.prismAutoDotTargetAndSelector;
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
