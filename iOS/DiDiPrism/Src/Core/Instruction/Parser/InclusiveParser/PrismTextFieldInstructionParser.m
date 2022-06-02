//
//  PrismTextFieldInstructionParser.m
//  DiDiPrism
//
//  Created by hulk on 2022/4/6.
//

#import "PrismTextFieldInstructionParser.h"
#import "PrismBaseInstructionParser+Protected.h"
// Category
#import "NSArray+PrismExtends.h"
// Util
#import "PrismInstructionAreaInfoUtil.h"

@interface PrismTextFieldInstructionParser()

@end

@implementation PrismTextFieldInstructionParser
#pragma mark - life cycle

#pragma mark - public method
- (NSObject *)parseWithFormatter:(PrismInstructionFormatter *)formatter {
    UITextField *targetControl = nil;
    // 解析响应链信息
    NSArray<NSString*> *viewPathArray = [formatter instructionFragmentWithType:PrismInstructionFragmentTypeViewPath];
    UIResponder *responder = [self searchRootResponderWithClassName:[viewPathArray prism_stringWithIndex:1]];
    if (!responder) {
        return nil;
    }
    
    NSArray<UIResponder*> *allPossibleResponder = [NSArray arrayWithObject:responder];
    for (NSInteger index = 2; index < viewPathArray.count; index++) {
        Class class = NSClassFromString(viewPathArray[index]);
        if (!class) {
            break;
        }
        NSArray<UIResponder*> *result = [self searchRespondersWithClassName:viewPathArray[index] superResponders:allPossibleResponder];
        if (!result.count) {
            break;
        }
        allPossibleResponder = result;
    }
    
    for (UIResponder *possibleResponder in allPossibleResponder) {
        
        UIView *targetView = [possibleResponder isKindOfClass:[UIViewController class]] ? [(UIViewController*)possibleResponder view] : (UIView*)possibleResponder;
        // 解析列表信息
        NSArray<NSString*> *viewListArray = [formatter instructionFragmentWithType:PrismInstructionFragmentTypeViewList];
        for (NSInteger index = 1; index < viewListArray.count; index = index + 4) {
            if ([NSClassFromString(viewListArray[index]) isSubclassOfClass:[UIScrollView class]]) {
                // 兼容模式直接省略对列表信息的解析。
                if (!self.isCompatibleMode) {
                    NSString *scrollViewClassName = viewListArray[index];
                    NSString *cellClassName = viewListArray[index + 1];
                    CGFloat cellSectionOrOriginX = viewListArray[index + 2].floatValue;
                    CGFloat cellRowOrOriginY = viewListArray[index + 3].floatValue;
                    UIView *scrollViewCell = [self searchScrollViewCellWithScrollViewClassName:scrollViewClassName
                                                                                 cellClassName:cellClassName
                                                                          cellSectionOrOriginX:cellSectionOrOriginX
                                                                              cellRowOrOriginY:cellRowOrOriginY
                                                                                 fromSuperView:targetView];
                    if (!scrollViewCell) {
                        targetView = nil;
                        break;
                    }
                    targetView = scrollViewCell;
                }
            }
        }
        if (!targetView) {
            continue;
        }
        
        // 解析区位信息+功能信息
        NSArray<NSString*> *viewQuadrantArray = [formatter instructionFragmentWithType:PrismInstructionFragmentTypeViewQuadrant];
        NSArray<NSString*> *viewFunctionArray = [formatter instructionFragmentWithType:PrismInstructionFragmentTypeViewFunction];

        NSString *areaInfo = [viewQuadrantArray prism_stringWithIndex:1];
        if (viewFunctionArray.count) {
            NSString *viewFunction = [viewFunctionArray prism_stringWithIndex:1];
            targetControl = [self searchTextFieldWithArea:areaInfo withViewFunction:viewFunction fromSuperView:targetView];
        }
        
        if (targetControl) {
            break;
        }
    }
    
    return targetControl;
}

#pragma mark - private method
- (UIControl*)searchTextFieldWithArea:(NSString*)areaInfo
                     withViewFunction:(NSString*)viewFunction
                        fromSuperView:(UIView*)superView {
    if ([superView isKindOfClass:[UITextField class]]) {
        UITextField *control = (UITextField*)superView;
        NSString *controlAreaInfo = [[PrismInstructionAreaInfoUtil getAreaInfoWithElement:control] prism_stringWithIndex:1];
        NSString *controlViewFunction = control.placeholder.length ? [NSString stringWithFormat:@"%@%@", kViewRepresentativeContentTypeText, control.placeholder] : nil;;
        BOOL isAreaInfoEqual = [self isAreaInfoEqualBetween:controlAreaInfo withAnother:areaInfo allowCompatibleMode:NO];
        if (isAreaInfoEqual &&
            (!viewFunction.length || ([viewFunction isEqualToString:controlViewFunction]))) {
            return control;
        }
    }
    
    if (!superView.subviews.count) {
        return nil;
    }
    for (UIView *view in superView.subviews) {
        UIControl *control = [self searchTextFieldWithArea:areaInfo withViewFunction:viewFunction fromSuperView:view];
        if (control) {
            return control;
        }
    }
    return nil;
}

#pragma mark - setters

#pragma mark - getters

@end
