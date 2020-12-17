//
//  PrismControlInstructionParser.m
//  DiDiPrism
//
//  Created by hulk on 2019/7/25.
//

#import "PrismControlInstructionParser.h"
#import "PrismBaseInstructionParser+Protected.h"
#import "PrismControlInstructionGenerator.h"
// Category
#import "UIControl+PrismIntercept.h"
#import "UIImage+PrismIntercept.h"
#import "NSArray+PrismExtends.h"
// Util
#import "PrismInstructionAreaUtil.h"
#import "PrismInstructionContentUtil.h"

@interface PrismControlInstructionParser()

@end

@implementation PrismControlInstructionParser
#pragma mark - life cycle

#pragma mark - public method
- (PrismInstructionParseResult)parseWithFormatter:(PrismInstructionFormatter *)formatter {
    UIControl *targetControl = nil;
    // 解析响应链信息
    NSArray<NSString*> *viewPathArray = [formatter instructionFragmentWithType:PrismInstructionFragmentTypeViewPath];
    UIResponder *responder = [self searchRootResponderWithClassName:[viewPathArray prism_stringWithIndex:1]];
    if (!responder) {
        return PrismInstructionParseResultFail;
    }
    
    for (NSInteger index = 2; index < viewPathArray.count; index++) {
        Class class = NSClassFromString(viewPathArray[index]);
        // 针对弹窗，vp的最后一位会记录控件信息，略过。因为后续逻辑会考虑。
        if (!class || [class isSubclassOfClass:[UIControl class]]) {
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
    UIView *targetView = [responder isKindOfClass:[UIViewController class]] ? [(UIViewController*)responder view] : (UIView*)responder;
    UIView *lastScrollView = nil;
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
    if (viewRepresentativeContentArray.count && viewFunctionArray.count) {
        NSString *representativeContent = [viewRepresentativeContentArray prism_stringWithIndex:1];
        Class targetClass = NSClassFromString([viewFunctionArray prism_objectAtIndex:1]);
        NSString *targetAction = [viewFunctionArray prism_stringWithIndex:2];
        targetControl = [self searchControlWithArea:areaInfo withRepresentativeContent:representativeContent withFunctionName:nil withTargetClass:targetClass withAction:targetAction fromSuperView:targetView];
        // 有列表的场景，考虑到列表中的元素index可能会变化，可以做一定的兼容。
        if (!targetControl && lastScrollView) {
            for (UIView *subview in lastScrollView.subviews) {
                UIControl *resultControl = [self searchControlWithArea:areaInfo withRepresentativeContent:representativeContent withFunctionName:nil withTargetClass:targetClass withAction:targetAction fromSuperView:subview];
                if (resultControl) {
                    targetControl = resultControl;
                    break;
                }
            }
        }
        if (!targetControl) {
            targetControl = [self searchControlWithArea:areaInfo withTargetClass:targetClass withAction:targetAction fromSuperView:targetView];
        }
    }
    // title or image + target + selector
    else if (viewFunctionArray.count == 4) {
        NSString *functionName = [viewFunctionArray prism_objectAtIndex:1];
        Class targetClass = NSClassFromString([viewFunctionArray prism_objectAtIndex:2]);
        NSString *targetAction = [viewFunctionArray prism_stringWithIndex:3];
        targetControl = [self searchControlWithArea:areaInfo withRepresentativeContent:nil withFunctionName:functionName withTargetClass:targetClass withAction:targetAction fromSuperView:targetView];
        // 有列表的场景，考虑到列表中的元素index可能会变化，可以做一定的兼容。
        if (!targetControl && lastScrollView) {
            for (UIView *subview in lastScrollView.subviews) {
                targetControl = [self searchControlWithArea:areaInfo withRepresentativeContent:nil withFunctionName:functionName withTargetClass:targetClass withAction:targetAction fromSuperView:subview];
                if (targetControl) {
                    break;
                }
            }
        }
        if (!targetControl) {
            targetControl = [self searchControlWithArea:areaInfo withTargetClass:targetClass withAction:targetAction fromSuperView:targetView];
        }
    }
    // target + selector
    else if (viewFunctionArray.count == 3) {
        Class targetClass = NSClassFromString([viewFunctionArray prism_objectAtIndex:1]);
        NSString *targetAction = [viewFunctionArray prism_stringWithIndex:2];
        targetControl = [self searchControlWithArea:areaInfo withTargetClass:targetClass withAction:targetAction fromSuperView:targetView];
        // 有列表的场景，考虑到列表中的元素index可能会变化，可以做一定的兼容。
        if (!targetControl && lastScrollView) {
            for (UIView *subview in lastScrollView.subviews) {
                targetControl = [self searchControlWithArea:areaInfo withTargetClass:targetClass withAction:targetAction fromSuperView:subview];
                if (targetControl) {
                    break;
                }
            }
        }
    }
    // title or image
    else if (viewFunctionArray.count == 2) {
        NSString *functionName = [viewFunctionArray prism_objectAtIndex:1];
        targetControl = [self searchControlWithArea:areaInfo withFunctionName:functionName fromSuperView:targetView];
        // 有列表的场景，考虑到列表中的元素index可能会变化，可以做一定的兼容。
        if (!targetControl && lastScrollView) {
            for (UIView *subview in lastScrollView.subviews) {
                targetControl = [self searchControlWithArea:areaInfo withFunctionName:functionName fromSuperView:subview];
                if (targetControl) {
                    break;
                }
            }
        }
    }
    
    if (targetControl) {
        [self scrollToIdealOffsetWithScrollView:(UIScrollView*)lastScrollView targetElement:targetControl];
        [self highlightTheElement:targetControl withCompletion:^{
            [targetControl sendActionsForControlEvents:UIControlEventAllTouchEvents];
        }];
        
        return PrismInstructionParseResultSuccess;
    }
    return PrismInstructionParseResultFail;
}

#pragma mark - private method
- (UIControl*)searchControlWithArea:(NSString*)areaInfo withFunctionName:(NSString*)functionName fromSuperView:(UIView*)superView {
    return [self searchControlWithArea:areaInfo withRepresentativeContent:nil withFunctionName:functionName withTargetClass:nil withAction:nil fromSuperView:superView];
}

- (UIControl*)searchControlWithArea:(NSString*)areaInfo withTargetClass:(Class)targetClass withAction:(NSString*)action fromSuperView:(UIView*)superView {
    return [self searchControlWithArea:areaInfo withRepresentativeContent:nil withFunctionName:nil withTargetClass:targetClass withAction:action fromSuperView:superView];
}

- (UIControl*)searchControlWithArea:(NSString*)areaInfo
          withRepresentativeContent:(NSString*)representativeContent
                   withFunctionName:(NSString*)functionName
                    withTargetClass:(Class)targetClass
                         withAction:(NSString*)action
                      fromSuperView:(UIView*)superView {
    if ([superView isKindOfClass:[UIControl class]]) {
        UIControl *control = (UIControl*)superView;
        NSString *areaAndListInfo = [PrismInstructionAreaUtil getAreaInfoWithElement:control];
        NSString *functionInfo = [PrismControlInstructionGenerator getFunctionNameOfControl:control];
        PrismInstructionFormatter *controlFormatter = [[PrismInstructionFormatter alloc] initWithInstruction:[NSString stringWithFormat:@"%@%@", areaAndListInfo, functionInfo]];
        NSString *controlAreaInfo = [[controlFormatter instructionFragmentWithType:PrismInstructionFragmentTypeViewQuadrant] prism_stringWithIndex:1];
        NSString *viewContent = [PrismInstructionContentUtil getRepresentativeContentOfView:control needRecursive:YES];
        NSString *controlFunctionName = [[controlFormatter instructionFragmentWithType:PrismInstructionFragmentTypeViewFunction] prism_stringWithIndex:1];
        control.highlighted = YES;
        NSString *highlightedImageName = nil;
        if ([control isKindOfClass:[UIButton class]]) {
            highlightedImageName = ((UIButton*)control).imageView.image.autoDotImageName;
        }
        control.highlighted = NO;
        for (NSObject *target in control.allTargets) {
            NSMutableArray<NSString*> *controlActions = [NSMutableArray array];
            NSInteger value = 1;
            while (value <= (2 << 19)) {
                if (control.allControlEvents & value) {
                    [controlActions addObjectsFromArray:[control actionsForTarget:target forControlEvent:value]];
                }
                value = value << 1;
            }
            BOOL isAreaInfoEqual = [self isAreaInfoEqualBetween:controlAreaInfo withAnother:areaInfo allowCompatibleMode:NO];
            if (isAreaInfoEqual
                && (!representativeContent.length || [representativeContent isEqualToString:viewContent])
                && (!functionName.length || ([controlFunctionName isEqualToString:functionName] || [highlightedImageName isEqualToString:functionName]))
                && (!targetClass || [target isKindOfClass:targetClass])
                && (!action.length || [controlActions containsObject:action])) {
                return control;
            }
        }
    }
    
    if (!superView.subviews.count) {
        return nil;
    }
    for (UIView *view in superView.subviews) {
        UIControl *control = [self searchControlWithArea:areaInfo withRepresentativeContent:representativeContent withFunctionName:functionName withTargetClass:targetClass withAction:action fromSuperView:view];
        if (control) {
            return control;
        }
    }
    return nil;
}
#pragma mark - setters

#pragma mark - getters

@end
