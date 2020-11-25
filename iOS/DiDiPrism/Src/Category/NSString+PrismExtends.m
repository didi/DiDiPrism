//
//  NSString+PrismExtends.m
//  DiDiPrism
//
//  Created by hulk on 2020/9/23.
//
//

#import "NSString+PrismExtends.h"

@implementation NSString (PrismExtends)

- (NSString *)prism_trimmingWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)prism_trimmingWhitespaceAndNewlines {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
