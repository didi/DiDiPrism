//
//  PrismLongPressGestureInstructionGenerator.m
//  DiDiPrism
//
//  Created by hulk on 2021/6/25.
//

#import "PrismLongPressGestureInstructionGenerator.h"
#import "PrismInstructionDefines.h"
// Util
#import "PrismInstructionResponseChainInfoUtil.h"
#import "PrismInstructionContentUtil.h"
// Category
#import "UIResponder+PrismIntercept.h"
#import "UIImage+PrismIntercept.h"
#import "UIView+PrismExtends.h"
#import "NSArray+PrismExtends.h"
#import "UIGestureRecognizer+PrismExtends.h"

@implementation PrismLongPressGestureInstructionGenerator
#pragma mark - life cycle

#pragma mark - public method
+ (PrismInstructionModel *)getInstructionModelOfLongPressGesture:(UILongPressGestureRecognizer *)longPressGesture {
    UIView *view = longPressGesture.view;
    if (!view) {
        return nil;
    }
    PrismInstructionModel *model = [[PrismInstructionModel alloc] init];
    model.vm = kViewMotionLongPressGestureFlag;
    model.vp = [longPressGesture prismAutoDotResponseChainInfo];
    NSArray *areaInfo = [longPressGesture prismAutoDotAreaInfo];
    model.vl = [areaInfo prism_stringWithIndex:0];
    model.vq = [areaInfo prism_stringWithIndex:1];
    model.vr = [PrismInstructionContentUtil getRepresentativeContentOfView:view needRecursive:YES];
    model.vf = [self getFunctionNameOfLongPressGesture:longPressGesture];
    return model;
}

+ (NSString*)getFunctionNameOfLongPressGesture:(UILongPressGestureRecognizer*)longPressGesture {
    UIView *view = longPressGesture.view;
    
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
            return [NSString stringWithFormat:@"%@_&_%@", functionName, longPressGesture.prismAutoDotTargetAndSelector];
        }
    }
    
    return longPressGesture.prismAutoDotTargetAndSelector;
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
