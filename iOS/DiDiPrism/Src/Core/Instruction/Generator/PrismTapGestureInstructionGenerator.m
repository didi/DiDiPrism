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
// Category
#import "UITapGestureRecognizer+PrismIntercept.h"
#import "UIResponder+PrismIntercept.h"
#import "UIImage+PrismIntercept.h"
#import "UIView+PrismExtends.h"
#import "NSArray+PrismExtends.h"

@interface PrismTapGestureInstructionGenerator()

@end

@implementation PrismTapGestureInstructionGenerator
#pragma mark - life cycle

#pragma mark - public method
+ (NSString*)getInstructionOfTapGesture:(UITapGestureRecognizer*)tapGesture {
    UIView *view = tapGesture.view;
    if (!view) {
        return nil;
    }
    if (view.prismAutoDotFinalMark.length) {
        return view.prismAutoDotFinalMark;
    }
    
    NSString *responseChainInfo = [tapGesture prismAutoDotResponseChainInfo];
    NSArray *areaInfo = [tapGesture prismAutoDotAreaInfo];
    NSString *listInfo = [areaInfo prism_stringWithIndex:0];
    NSString *quadrantInfo = [areaInfo prism_stringWithIndex:1];
    // 屏蔽Native侧的H5页面点击指令
    if (([listInfo containsString:@"WKScrollView"] || [listInfo containsString:@"WKContentView"])) {
        return nil;
    }
    NSString *viewContent = [PrismInstructionContentUtil getRepresentativeContentOfView:view needRecursive:YES];
    NSString *functionName = [self getFunctionNameOfTapGesture:tapGesture];
    NSString *instruction = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@", kBeginOfViewMotionFlag, kViewMotionTapGestureFlag, kBeginOfViewPathFlag , responseChainInfo ?: @"", kBeginOfViewListFlag, listInfo ?: @"", kBeginOfViewQuadrantFlag, quadrantInfo ?: @"", kBeginOfViewRepresentativeContentFlag, viewContent ?: @"", kBeginOfViewFunctionFlag, functionName ?: @""];
    // 注：列表中的cell存在复用机制，cell复用时指令不可复用。
    if (listInfo.length) {
        return instruction;
    }
    else {
        view.prismAutoDotFinalMark = instruction;
        return view.prismAutoDotFinalMark;
    }
}

+ (PrismInstructionModel *)getInstructionModelOfTapGesture:(UITapGestureRecognizer *)tapGesture {
    UIView *view = tapGesture.view;
    if (!view) {
        return nil;
    }
    PrismInstructionModel *model = [[PrismInstructionModel alloc] init];
    model.vm = kViewMotionTapGestureFlag;
    model.vp = [tapGesture prismAutoDotResponseChainInfo];
    NSArray *areaInfo = [tapGesture prismAutoDotAreaInfo];
    model.vl = [areaInfo prism_stringWithIndex:0];
    model.vq = [areaInfo prism_stringWithIndex:1];
    // 屏蔽Native侧的H5页面点击指令
    if (([model.vl containsString:@"WKScrollView"] || [model.vl containsString:@"WKContentView"])) {
        return nil;
    }
    model.vr = [PrismInstructionContentUtil getRepresentativeContentOfView:view needRecursive:YES];
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
        else {
            return tapGesture.prismAutoDotTargetAndSelector;
        }
    }
    // Native
    else {
        return tapGesture.prismAutoDotTargetAndSelector;
    }
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
