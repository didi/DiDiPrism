//
//  PrismH5InstructionParser.m
//  DiDiPrism
//
//  Created by hulk on 2020/4/17.
//

#import "PrismH5InstructionParser.h"

@interface PrismH5InstructionParser()

@end

@implementation PrismH5InstructionParser
#pragma mark - life cycle

#pragma mark - public method
- (PrismInstructionParseResult)parseWithFormatter:(PrismInstructionFormatter *)formatter {
    NSArray<NSString*> *h5ViewArray = [formatter instructionFragmentWithType:PrismInstructionFragmentTypeH5View];
    if (h5ViewArray.count < 2) {
        return PrismInstructionParseResultError;
    }

    return PrismInstructionParseResultError;
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
