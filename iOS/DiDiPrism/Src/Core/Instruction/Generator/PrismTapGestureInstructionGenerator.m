//
//  PrismTapGestureInstructionGenerator.m
//  DiDiPrism
//
//  Created by hulk on 2020/9/24.
//

#import "PrismTapGestureInstructionGenerator.h"
#import "PrismInstructionDefines.h"
// Util
#import "PrismInstructionResponseChainUtil.h"
#import "PrismInstructionContentUtil.h"
// Category
#import "UITapGestureRecognizer+PrismIntercept.h"
#import "UIResponder+PrismIntercept.h"
#import "UIImage+PrismIntercept.h"
#import "UIView+PrismExtends.h"

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
    if (view.autoDotFinalMark.length) {
        return view.autoDotFinalMark;
    }
    
    NSString *responseChainInfo = [tapGesture autoDotResponseChainInfo];
    NSString *areaInfo = [tapGesture autoDotAreaInfo];
    // 屏蔽Native侧的H5页面点击指令
    if (([areaInfo containsString:@"WKScrollView"] || [areaInfo containsString:@"WKContentView"])) {
        return nil;
    }
    NSString *functionName = [self getFunctionNameOfTapGesture:tapGesture];
    NSString *instruction = [NSString stringWithFormat:@"%@%@%@%@%@", kBeginOfViewMotionFlag, kViewMotionTapGestureFlag, responseChainInfo, areaInfo, functionName];
    // 注：列表中的cell存在复用机制，cell复用时指令不可复用。
    if ([areaInfo containsString:kBeginOfViewListFlag]) {
        return instruction;
    }
    else {
        view.autoDotFinalMark = instruction;
        return view.autoDotFinalMark;
    }
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
        NSString *representativeContent = [PrismInstructionContentUtil getRepresentativeContentOfView:view needRecursive:YES];
        if (representativeContent.length) {
            [functionName appendFormat:@"%@", representativeContent];
        }
        if (([wxFunctionName isKindOfClass:[NSString class]] && wxFunctionName.length)
            || ([wxClassName isKindOfClass:[NSString class]] && wxClassName.length)) {
            
            if (functionName.length) {
                [functionName insertString:kBeginOfViewRepresentativeContentFlag atIndex:0];
            }
            NSMutableString *mutableFunctionName = [NSMutableString stringWithString:kBeginOfViewFunctionFlag];
            if ([wxFunctionName isKindOfClass:[NSString class]] && wxFunctionName.length) {
                [mutableFunctionName appendString:wxFunctionName];
            }
            if ([wxClassName isKindOfClass:[NSString class]] && wxClassName.length) {
                if (mutableFunctionName.length) {
                    [mutableFunctionName appendString:@"-"];
                }
                [mutableFunctionName appendString:wxClassName];
            }
            if (![mutableFunctionName isEqualToString:kBeginOfViewFunctionFlag]) {
                [functionName appendString:[mutableFunctionName copy]];
            }
        }
        else {
            if (functionName.length) {
                [functionName insertString:kBeginOfViewFunctionFlag atIndex:0];
            }
        }
        
        if (functionName.length) {
            return [NSString stringWithFormat:@"%@_&_%@", functionName, tapGesture.autoDotTargetAndSelector];
        }
    }
    // 获取有代表性的内容便于更好的定位view
    NSString *viewContent = [PrismInstructionContentUtil getRepresentativeContentOfView:view needRecursive:YES];
    if (viewContent.length) {
        return [NSString stringWithFormat:@"%@%@%@%@", kBeginOfViewRepresentativeContentFlag, viewContent, kBeginOfViewFunctionFlag, tapGesture.autoDotTargetAndSelector];
    }
    return [NSString stringWithFormat:@"%@%@", kBeginOfViewFunctionFlag, tapGesture.autoDotTargetAndSelector];
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
