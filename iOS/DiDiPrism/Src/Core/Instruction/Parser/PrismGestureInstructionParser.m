//
//  PrismGestureInstructionParser.m
//  DiDiPrism
//
//  Created by hulk on 2019/7/25.
//

#import "PrismGestureInstructionParser.h"
#import "PrismBaseInstructionParser+Protected.h"
#import "PrismTapGestureInstructionGenerator.h"
// Category
#import "UITapGestureRecognizer+PrismIntercept.h"
#import "NSArray+PrismExtends.h"
// Util
#import "PrismInstructionAreaUtil.h"

@interface PrismGestureInstructionParser()

@end

@implementation PrismGestureInstructionParser
#pragma mark - life cycle

#pragma mark - public method
- (PrismInstructionParseResult)parseWithFormatter:(PrismInstructionFormatter *)formatter {
    // 解析响应链信息
    NSArray<NSString*> *viewPathArray = [formatter instructionFragmentWithType:PrismInstructionFragmentTypeViewPath];
    UIResponder *responder = [self searchRootResponderWithClassName:[viewPathArray prism_stringWithIndex:1]];
    if (!responder) {
        return PrismInstructionParseResultFail;
    }
    
    for (NSInteger index = 2; index < viewPathArray.count; index++) {
        Class class = NSClassFromString(viewPathArray[index]);
        if (!class) {
            break;
        }
        UIResponder *result = [self searchResponderWithClassName:viewPathArray[index] superResponder:responder];
        if (!result) {
            break;
        }
        responder = result;
    }
    
    // 解析列表信息
    NSArray<NSString*> *viewListArray = [formatter instructionFragmentWithType:PrismInstructionFragmentTypeViewList];
    UIView *lastScrollView = nil;
    UIView *targetView = [responder isKindOfClass:[UIViewController class]] ? [(UIViewController*)responder view] : (UIView*)responder;
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
                    return PrismInstructionParseResultFail;
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
    UITapGestureRecognizer *tapGesture = nil;
    // WEEX参考信息 + WEEX标签信息 + selector + action
    if (viewRepresentativeContentArray.count && viewFunctionArray.count == 4) {
        NSString *representativeContent = [viewRepresentativeContentArray prism_stringWithIndex:1];
        NSString *functionName = [viewFunctionArray prism_stringWithIndex:1];
        tapGesture = [self searchTapGestureFromSuperView:targetView withAreaInfo:areaInfo withRepresentativeContent:representativeContent withFunctionName:functionName];
        if (!tapGesture) {
            // 有列表的场景，考虑到列表中的元素index可能会变化，可以做一定的兼容。
            if (representativeContent.length && lastScrollView) {
                for (UIView *subview in lastScrollView.subviews) {
                    UITapGestureRecognizer *resultGesture = [self searchTapGestureFromSuperView:subview withAreaInfo:areaInfo withRepresentativeContent:representativeContent withFunctionName:functionName];
                    if (resultGesture) {
                        tapGesture = resultGesture;
                        break;
                    }
                }
            }
        }
        if (!tapGesture) {
            // 兜底处理
            tapGesture = [self searchTapGestureFromSuperView:targetView withAreaInfo:areaInfo withRepresentativeContent:nil withFunctionName:functionName];
        }
    }
    // WEEX参考信息 + selector + action
    else if (viewRepresentativeContentArray.count && viewFunctionArray.count < 4) {
        NSString *representativeContent = [viewRepresentativeContentArray prism_stringWithIndex:1];
        tapGesture = [self searchTapGestureFromSuperView:targetView withAreaInfo:areaInfo withRepresentativeContent:representativeContent withFunctionName:nil];
        if (!tapGesture) {
            // 有列表的场景，考虑到列表中的元素index可能会变化，可以做一定的兼容。
            if (representativeContent.length && lastScrollView) {
                for (UIView *subview in lastScrollView.subviews) {
                    UITapGestureRecognizer *resultGesture = [self searchTapGestureFromSuperView:subview withAreaInfo:areaInfo withRepresentativeContent:representativeContent withFunctionName:nil];
                    if (resultGesture) {
                        tapGesture = resultGesture;
                        break;
                    }
                }
            }
        }
        if (!tapGesture) {
            // 兜底处理
            tapGesture = [self searchTapGestureFromSuperView:targetView withAreaInfo:areaInfo withRepresentativeContent:nil withFunctionName:nil];
        }
    }
    // title or image + selector + action
    // 或 title or image + 空字符串 + selector + action （在WEEX的@click和class未被正则匹配到时，即functionName和className不存在时，会出现）
    else if (viewFunctionArray.count == 4 || viewFunctionArray.count == 5) {
        NSString *functionName = [viewFunctionArray prism_stringWithIndex:1];
        tapGesture = [self searchTapGestureFromSuperView:targetView withAreaInfo:areaInfo withRepresentativeContent:nil withFunctionName:functionName];
    }
    // selector + action
    else if (viewFunctionArray.count == 3) {
        tapGesture = [self searchTapGestureFromSuperView:targetView withAreaInfo:areaInfo withRepresentativeContent:nil withFunctionName:nil];
        // 有列表的场景，考虑到列表中的元素index可能会变化，可以做一定的兼容。
        if (!tapGesture && lastScrollView) {
            for (UIView *subview in lastScrollView.subviews) {
                UITapGestureRecognizer *resultGesture = [self searchTapGestureFromSuperView:subview withAreaInfo:areaInfo withRepresentativeContent:nil withFunctionName:nil];
                if (resultGesture) {
                    tapGesture = resultGesture;
                    break;
                }
            }
        }
    }
    
    if (tapGesture) {
        [self scrollToIdealOffsetWithScrollView:(UIScrollView*)lastScrollView targetElement:tapGesture.view];
        [self highlightTheElement:tapGesture.view withCompletion:^{
            [tapGesture setState:UIGestureRecognizerStateRecognized];
        }];
        return PrismInstructionParseResultSuccess;
    }
    return PrismInstructionParseResultFail;
}

#pragma mark - private method
- (UITapGestureRecognizer*)searchTapGestureFromSuperView:(UIView*)superView
                                            withAreaInfo:(NSString*)areaInfo
                               withRepresentativeContent:(NSString*)representativeContent
                                        withFunctionName:(NSString*)functionName {
    for (UIGestureRecognizer *gesture in superView.gestureRecognizers) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer*)gesture;
            NSString *areaAndListInfo = [PrismInstructionAreaUtil getAreaInfoWithElement:tapGesture.view];
            NSString *functionInfo = [PrismTapGestureInstructionGenerator getFunctionNameOfTapGesture:tapGesture];
            PrismInstructionFormatter *gestureFormatter = [[PrismInstructionFormatter alloc] initWithInstruction:[NSString stringWithFormat:@"%@%@", areaAndListInfo, functionInfo]];
            NSString *gestureViewAreaInfo = [[gestureFormatter instructionFragmentWithType:PrismInstructionFragmentTypeViewQuadrant] prism_stringWithIndex:1];
            NSArray<NSString*> *representativeContentArray = [gestureFormatter instructionFragmentWithType:PrismInstructionFragmentTypeViewRepresentativeContent];
            NSArray<NSString*> *functionNameArray = [gestureFormatter instructionFragmentWithType:PrismInstructionFragmentTypeViewFunction];
            NSString *gestureFunctionName = functionNameArray.count ? [functionNameArray prism_stringWithIndex:1] : nil;
            NSString *gestureRepresentativeContent = representativeContentArray.count ? [representativeContentArray prism_stringWithIndex:1] : gestureFunctionName;
            
            BOOL isAreaInfoEqual = [self isAreaInfoEqualBetween:gestureViewAreaInfo withAnother:areaInfo allowCompatibleMode:functionName.length];
            if (isAreaInfoEqual
                && (!functionName.length || [functionName isEqualToString:gestureFunctionName])
                && (!representativeContent.length || [representativeContent isEqualToString:gestureRepresentativeContent])) {
                return (UITapGestureRecognizer*)gesture;
            }
        }
    }
    for (UIView *subview in superView.subviews) {
        UITapGestureRecognizer *tapGesture = [self searchTapGestureFromSuperView:subview withAreaInfo:areaInfo withRepresentativeContent:representativeContent withFunctionName:functionName];
        if (tapGesture) {
            return tapGesture;
        }
    }
    return nil;
}

#pragma mark - setters

#pragma mark - getters

@end
