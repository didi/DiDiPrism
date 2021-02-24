//
//  PrismIdentifierUtil.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import "PrismIdentifierUtil.h"

@implementation PrismIdentifierUtil
+ (NSString *)identifier {
    return @"_PRISM_Element_Identifier";
}

+ (BOOL)needHookWithView:(UIView *)view {
    if ([view.accessibilityIdentifier containsString:[self identifier]]
        || [view.accessibilityLabel containsString:[self identifier]]) {
        return NO;
    }
    return YES;
}

+ (BOOL)needHookWithGesture:(UIGestureRecognizer *)gesture {
    if ([gesture.accessibilityLabel containsString:[self identifier]]) {
        return NO;
    }
    return YES;
}
@end
