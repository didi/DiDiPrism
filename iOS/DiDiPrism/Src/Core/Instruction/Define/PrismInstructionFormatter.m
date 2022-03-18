//
//  PrismInstructionFormatter.m
//  DiDiPrism
//
//  Created by hulk on 2020/4/18.
//

#import "PrismInstructionFormatter.h"
// Category
#import "NSDictionary+PrismExtends.h"
#import "NSArray+PrismExtends.h"

@interface PrismInstructionFormatter()
@property (nonatomic, copy) NSString *instruction;
@property (nonatomic, copy) NSDictionary<NSString*, NSArray<NSString*>*> *instructionFragments;
@end

@implementation PrismInstructionFormatter
#pragma mark - life cycle
- (instancetype)init {
    self = [self initWithInstruction:nil];
    return self;
}

- (instancetype)initWithInstruction:(NSString*)instruction {
    self = [super init];
    if (self) {
        if (instruction.length) {
            self.instruction = instruction;
            self.instructionFragments = [self parseInstruction:self.instruction];
        }
    }
    return self;
}

#pragma mark - public method
- (NSArray<NSString *> *)instructionFragmentWithType:(PrismInstructionFragmentType)type {
    return [self.instructionFragments prism_arrayForKey:[self descriptionOfType:type]];
}

- (NSString*)instructionFragmentContentWithType:(PrismInstructionFragmentType)type {
    NSArray<NSString *> *fragments = [self.instructionFragments prism_arrayForKey:[self descriptionOfType:type]];
    if (fragments.count < 2) {
        return nil;
    }
    NSMutableString *fragmentContent = [NSMutableString string];
    for (NSInteger index = 1; index < fragments.count; index++) {
        NSString *content = [fragments prism_stringWithIndex:index];
        if (!content.length && index == fragments.count - 1) {
            break;
        }
        if (index != 1) {
            [fragmentContent appendString:kConnectorFlag];
        }
        [fragmentContent appendString:[fragments prism_stringWithIndex:index]];
    }
    return [fragmentContent copy];
}

#pragma mark - private method
- (NSDictionary<NSString*, NSArray<NSString*>*>*)parseInstruction:(NSString*)instruction {
    NSMutableDictionary<NSString*, NSArray<NSString*>*> *instructionFragments = [NSMutableDictionary dictionary];
    NSArray<NSString*> *fragments = [instruction componentsSeparatedByString:kFragmentFlag];
    for (NSString *fragment in fragments) {
        if (fragment.length) {
            NSArray<NSString*> *fragmentArray = [fragment componentsSeparatedByString:kConnectorFlag];
            [instructionFragments prism_setValue:fragmentArray forKey:fragmentArray[0]];
        }
    }
    return [instructionFragments copy];
}

- (NSString*)descriptionOfType:(PrismInstructionFragmentType)type {
    switch (type) {
        case PrismInstructionFragmentTypeViewMotion:
            return kViewMotionFlag;
            break;
        case PrismInstructionFragmentTypeViewPath:
            return kViewPathFlag;
            break;
        case PrismInstructionFragmentTypeViewTree:
            return kViewTreeFlag;
            break;
        case PrismInstructionFragmentTypeViewList:
            return kViewListFlag;
            break;
        case PrismInstructionFragmentTypeViewQuadrant:
            return kViewQuadrantFlag;
            break;
        case PrismInstructionFragmentTypeViewRepresentativeContent:
            return kViewRepresentativeContentFlag;
            break;
        case PrismInstructionFragmentTypeEvent:
            return kEventFlag;
            break;
        case PrismInstructionFragmentTypeViewFunction:
            return kViewFunctionFlag;
            break;
        case PrismInstructionFragmentTypeH5View:
            return kH5ViewFlag;
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark - setters

#pragma mark - getters

@end
