//
//  PrismBaseInstructionParser.m
//  DiDiPrism
//
//  Created by hulk on 2019/7/25.
//

#import "PrismBaseInstructionParser.h"
#import "PrismInstructionDefines.h"
// Category
#import "NSArray+PrismExtends.h"
// Parser
#import "PrismControlInstructionParser.h"
#import "PrismTapGestureInstructionParser.h"
#import "PrismCellInstructionParser.h"
#import "PrismTagInstructionParser.h"
#import "PrismEdgePanGestureInstructionParser.h"
#import "PrismH5InstructionParser.h"
#import "PrismLongPressGestureInstructionParser.h"

@interface PrismBaseInstructionParser()

@end

@implementation PrismBaseInstructionParser
#pragma mark - life cycle
+ (instancetype)instructionParserWithFormatter:(PrismInstructionFormatter*)formatter {
    if ([formatter instructionFragmentWithType:PrismInstructionFragmentTypeH5View].count) {
        return [[PrismH5InstructionParser alloc] init];
    }
    if ([formatter instructionFragmentWithType:PrismInstructionFragmentTypeEvent].count) {
        return [[PrismTagInstructionParser alloc] init];
    }
    
    NSArray<NSString*> *viewMotionArray = [formatter instructionFragmentWithType:PrismInstructionFragmentTypeViewMotion];
    NSString *viewMotion = [viewMotionArray prism_stringWithIndex:1];
    if ([viewMotion isEqualToString:kViewMotionControlFlag]) {
        return [[PrismControlInstructionParser alloc] init];
    }
    else if ([viewMotion isEqualToString:kViewMotionTapGestureFlag]) {
        return [[PrismTapGestureInstructionParser alloc] init];
    }
    else if ([viewMotion isEqualToString:kViewMotionCellFlag]) {
        return [[PrismCellInstructionParser alloc] init];
    }
    else if ([viewMotion isEqualToString:kViewMotionEdgePanGestureFlag]) {
        return [[PrismEdgePanGestureInstructionParser alloc] init];
    }
    else if ([viewMotion isEqualToString:kViewMotionLongPressGestureFlag]) {
        return [[PrismLongPressGestureInstructionParser alloc] init];
    }
    
    return [[PrismBaseInstructionParser alloc] init];
}

#pragma mark - public method
- (NSObject*)parseWithFormatter:(PrismInstructionFormatter *)formatter {
    return nil;
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
