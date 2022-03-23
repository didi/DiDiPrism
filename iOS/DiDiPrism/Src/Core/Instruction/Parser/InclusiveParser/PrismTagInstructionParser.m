//
//  PrismTagInstructionParser.m
//  DiDiPrism
//
//  Created by hulk on 2019/10/15.
//

#import "PrismTagInstructionParser.h"
#import "PrismInstructionDefines.h"

@interface PrismTagInstructionParser()

@end

@implementation PrismTagInstructionParser
#pragma mark - life cycle

#pragma mark - public method
- (NSObject *)parseWithFormatter:(PrismInstructionFormatter *)formatter {
    if ([formatter.instruction isEqualToString:kUIApplicationBecomeActive]) {
        return @"回到前台";
    }
    else if ([formatter.instruction isEqualToString:kUIApplicationResignActive]) {
        return @"切到后台";
    }
    return nil;
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
