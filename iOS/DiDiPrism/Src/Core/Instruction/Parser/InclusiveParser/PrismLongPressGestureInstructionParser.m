//
//  PrismLongPressGestureInstructionParser.m
//  DiDiPrism
//
//  Created by hulk on 2021/6/25.
//

#import "PrismLongPressGestureInstructionParser.h"
#import "PrismBaseInstructionParser+Protected.h"
#import "PrismLongPressGestureInstructionGenerator.h"
// Category
#import "NSArray+PrismExtends.h"
// Util
#import "PrismInstructionAreaInfoUtil.h"
#import "PrismInstructionContentUtil.h"

@implementation PrismLongPressGestureInstructionParser
#pragma mark - life cycle

#pragma mark - public method
- (NSObject *)parseWithFormatter:(PrismInstructionFormatter *)formatter {
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
    
    UILongPressGestureRecognizer *longPressGesture = nil;
    UIView *lastScrollView = nil;
    
    for (UIResponder *possibleResponder in allPossibleResponder) {
        
        lastScrollView = nil;
        // 解析列表信息
        NSArray<NSString*> *viewListArray = [formatter instructionFragmentWithType:PrismInstructionFragmentTypeViewList];
        UIView *targetView = [possibleResponder isKindOfClass:[UIViewController class]] ? [(UIViewController*)possibleResponder view] : (UIView*)possibleResponder;
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
                        return nil;
                    }
                    targetView = scrollViewCell;
                    lastScrollView = scrollViewCell.superview;
                }
            }
        }
        
        // 解析区位信息+功能信息
        NSArray<NSString*> *viewQuadrantArray = [formatter instructionFragmentWithType:PrismInstructionFragmentTypeViewQuadrant];
        NSArray<NSString*> *viewRepresentativeContentArray = [formatter instructionFragmentWithType:PrismInstructionFragmentTypeViewRepresentativeContent];
        NSArray<NSString*> *viewFunctionArray = [formatter instructionFragmentWithType:PrismInstructionFragmentTypeViewFunction];

        NSString *areaInfo = [viewQuadrantArray prism_stringWithIndex:1];
        // vr = 参考信息
        // 且
        // (
        // vf = WEEX标签信息 + selector + action
        // 或
        // vf = selector + action
        // )
        NSMutableString *representativeContent = [NSMutableString string];
        for (NSInteger index = 1; index < viewRepresentativeContentArray.count; index++) {
            if (index > 1) {
                [representativeContent appendString:kConnectorFlag];
            }
            [representativeContent appendString:[viewRepresentativeContentArray prism_stringWithIndex:index]];
        }
        
        NSMutableString *functionName = [NSMutableString string];
        for (NSInteger index = 1; index < viewFunctionArray.count; index++) {
            if (index > 1) {
                [functionName appendString:kConnectorFlag];
            }
            [functionName appendString:[viewFunctionArray prism_stringWithIndex:index]];
        }
        
        longPressGesture = [self searchLongPressGestureFromSuperView:targetView withAreaInfo:areaInfo withRepresentativeContent:[representativeContent copy] withFunctionName:functionName];
        if (!longPressGesture) {
            // 有列表的场景，考虑到列表中的元素index可能会变化，可以做一定的兼容。
            if (representativeContent.length && lastScrollView) {
                for (UIView *subview in lastScrollView.subviews) {
                    UITapGestureRecognizer *resultGesture = [self searchLongPressGestureFromSuperView:subview withAreaInfo:areaInfo withRepresentativeContent:[representativeContent copy] withFunctionName:functionName];
                    if (resultGesture) {
                        longPressGesture = resultGesture;
                        break;
                    }
                }
            }
        }
        if (!longPressGesture) {
            // 兜底处理
            longPressGesture = [self searchLongPressGestureFromSuperView:targetView withAreaInfo:areaInfo withRepresentativeContent:nil withFunctionName:functionName];
        }
        
        if (longPressGesture) {
            break;
        }
    }
    
    if (longPressGesture) {
        [self scrollToIdealOffsetWithScrollView:(UIScrollView*)lastScrollView targetElement:longPressGesture.view];
    }
    return longPressGesture;
}

#pragma mark - private method
- (UILongPressGestureRecognizer*)searchLongPressGestureFromSuperView:(UIView*)superView
                                                        withAreaInfo:(NSString*)areaInfo
                                           withRepresentativeContent:(NSString*)representativeContent
                                                    withFunctionName:(NSString*)functionName {
    for (UIGestureRecognizer *gesture in superView.gestureRecognizers) {
        if ([gesture isKindOfClass:[UILongPressGestureRecognizer class]]) {
            UILongPressGestureRecognizer *longPressGesture = (UILongPressGestureRecognizer*)gesture;
            NSString *gestureViewAreaInfo = [[PrismInstructionAreaInfoUtil getAreaInfoWithElement:longPressGesture.view] prism_stringWithIndex:1];
            NSString *gestureFunctionName = [PrismLongPressGestureInstructionGenerator getFunctionNameOfLongPressGesture:longPressGesture];
            NSString *gestureRepresentativeContent = [PrismInstructionContentUtil getRepresentativeContentOfView:superView needRecursive:YES];
            
            BOOL isAreaInfoEqual = [self isAreaInfoEqualBetween:gestureViewAreaInfo withAnother:areaInfo allowCompatibleMode:self.isCompatibleMode];
            if (isAreaInfoEqual
                && (!functionName.length || [functionName isEqualToString:gestureFunctionName])
                && (!representativeContent.length || [representativeContent isEqualToString:gestureRepresentativeContent])) {
                return (UILongPressGestureRecognizer*)gesture;
            }
        }
    }
    for (UIView *subview in superView.subviews) {
        UILongPressGestureRecognizer *longPressGesture = [self searchLongPressGestureFromSuperView:subview withAreaInfo:areaInfo withRepresentativeContent:representativeContent withFunctionName:functionName];
        if (longPressGesture) {
            return longPressGesture;
        }
    }
    return nil;
}

#pragma mark - setters

#pragma mark - getters

@end
