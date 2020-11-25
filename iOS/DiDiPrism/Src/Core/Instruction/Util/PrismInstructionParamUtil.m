//
//  PrismInstructionParamUtil.m
//  DiDiPrism
//
//  Created by hulk on 2020/10/27.
//

#import "PrismInstructionParamUtil.h"
// Category
#import "UIView+PrismExtends.h"
#import "UIResponder+PrismIntercept.h"
#import "NSDictionary+PrismExtends.h"

@interface PrismInstructionParamUtil()

@end

@implementation PrismInstructionParamUtil
#pragma mark - public method
+ (NSDictionary*)getEventParamsWithElement:(UIView*)element {
    UIView *view = element;
    if (!view) {
        return nil;
    }
    
    NSString *itemName = nil;
    // WEEX
    id wxComponent = [view prism_wxComponent];
    if (wxComponent && [wxComponent isKindOfClass:NSClassFromString(@"WXComponent")]) {
        NSDictionary *wxAttributes = [wxComponent valueForKey:@"attributes"];
        NSDictionary *easyLogParams = [wxAttributes prism_dictionaryForKey:@"easyLogParams"];
        if ([easyLogParams.allKeys containsObject:@"itemName"]) {
            itemName = [easyLogParams prism_stringForKey:@"itemName"];
        }
        else if ([wxAttributes.allKeys containsObject:@"easyItemName"]) {
            itemName = [wxAttributes prism_stringForKey:@"easyItemName"];
        }
    }
    // Native
    else {
        itemName = view.autoDotItemName;
    }
    
    if (itemName.length) {
        return @{@"itemName":itemName};
    }
    return nil;
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
