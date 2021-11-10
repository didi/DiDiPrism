//
//  PrismBehaviorDetectRuleConfigModel.m
//  DiDiPrism
//
//  Created by hulk on 2020/9/29.
//

#import "PrismBehaviorDetectRuleConfigModel.h"
#import <DiDiPrism/NSArray+PrismExtends.h>
#import <DiDiPrism/NSDictionary+PrismExtends.h>
#import <DiDiPrism/NSDate+PrismExtends.h>

#define PrismBehaviorDetectBasePointDefaultKey @"[ignore]";

#pragma mark - PrismBehaviorDetectRuleFragmentModel
@interface PrismBehaviorDetectRuleFragmentModel()

@end

@implementation PrismBehaviorDetectRuleFragmentModel
#pragma mark - life cycle

#pragma mark - public method
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"operatorString": @"operator"}];
}

- (BOOL)isEqualWithInstructionFragment:(NSString*)instructionFragment {
    if (!self.value.count) {
        return YES;
    }
    if (!instructionFragment) {
        return NO;
    }
    BOOL isEqual = YES;
    for (NSString *item in self.value) {
        if (!item.length) {
            continue;
        }
        if ([self.operatorString isEqualToString:@"="]) {
            isEqual = isEqual && [instructionFragment isEqualToString:item];
        }
        else if ([self.operatorString isEqualToString:@"%"]) {
            isEqual = isEqual && [instructionFragment containsString:item];
        }
    }
    return isEqual;
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end


#pragma mark - PrismBehaviorDetectRuleInstructionModel
@interface PrismBehaviorDetectRuleInstructionModel()

@end

@implementation PrismBehaviorDetectRuleInstructionModel
#pragma mark - life cycle

#pragma mark - public method
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

- (BOOL)isEqualWithInstructionFormatter:(PrismInstructionFormatter *)instructionFormatter {
    BOOL isEqual = YES;
    NSInteger typeCount = 8;
    for (NSInteger index = 0; index < typeCount; index++) {
        NSString *vContent = [instructionFormatter instructionFragmentContentWithType:index];
        PrismBehaviorDetectRuleFragmentModel *fragmentModel = [self fragmentModelWithType:index];
        if (!fragmentModel) {
            continue;
        }
        isEqual = isEqual && [fragmentModel isEqualWithInstructionFragment:vContent];
    }
    return isEqual;
}

#pragma mark - private method
- (PrismBehaviorDetectRuleFragmentModel*)fragmentModelWithType:(PrismInstructionFragmentType)type {
    switch (type) {
        case PrismInstructionFragmentTypeViewMotion:
            return self.vm;
            break;
        case PrismInstructionFragmentTypeViewPath:
            return self.vp;
            break;
        case PrismInstructionFragmentTypeViewList:
            return self.vl;
            break;
        case PrismInstructionFragmentTypeViewQuadrant:
            return self.vq;
            break;
        case PrismInstructionFragmentTypeViewRepresentativeContent:
            return self.vr;
            break;
        case PrismInstructionFragmentTypeEvent:
            return self.e;
            break;
        case PrismInstructionFragmentTypeViewFunction:
            return self.vf;
            break;
        case PrismInstructionFragmentTypeH5View:
            return self.h5;
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark - setters

#pragma mark - getters

@end


#pragma mark - PrismBehaviorDetectRuleExpressionModel
@interface PrismBehaviorDetectRuleExpressionModel()

@end

@implementation PrismBehaviorDetectRuleExpressionModel
#pragma mark - life cycle

#pragma mark - public method
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"operatorString": @"operator"}];
}

- (PrismBehaviorDetectRuleExpressionModel*)searchBasePointModel {
    if (self.basePoint.integerValue == 1) {
        return self;
    }
    return nil;
}

- (BOOL)isEstablishedWithBasePointResultKey:(NSString *)basePointResultKey {
    if ([self.operatorString isEqualToString:@"gte"]) {
        NSInteger typeValue = [self.typeValue prism_stringWithIndex:0].integerValue;
        if (typeValue <= [self getValueWithBasePointResultKey:basePointResultKey]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)feedInstructionFormatter:(PrismInstructionFormatter *)instructionFormatter
                            withParams:(NSDictionary *)params
                      withBasePointKey:(NSString *)basePointKey {
    if (!instructionFormatter) {
        return nil;
    }
    BOOL isRight = YES;
    if (self.itemName.length) {
        NSString *itemName = [params prism_stringForKey:@"itemName"];
        isRight = isRight && [self.itemName isEqualToString:itemName];
        if (!isRight) {
            return nil;
        }
    }
    BOOL isInstructionEstablished = NO;
    for (PrismBehaviorDetectRuleInstructionModel *instructionModel in self.instruction) {
        isInstructionEstablished = isInstructionEstablished || [instructionModel isEqualWithInstructionFormatter:instructionFormatter];
        if (isInstructionEstablished) {
            break;
        }
    }
    isRight = isRight && isInstructionEstablished;
    if (isRight) {
        [self plusValueWithInstructionFormatter:instructionFormatter withParams:params withBasePointKey:basePointKey];

        if (self.basePoint.integerValue == 1) {
            NSString *vrContent = [instructionFormatter instructionFragmentContentWithType:PrismInstructionFragmentTypeViewRepresentativeContent];
            NSString *itemName = [params prism_stringForKey:@"itemName"];
            return [NSString stringWithFormat:@"%@-%@", vrContent ? : @"", itemName ? : @""];
        }
    }
    return nil;
}

- (void)reset {
    [self.currentValues removeAllObjects];
    [self.currentDays removeAllObjects];
}

#pragma mark - private method
- (NSInteger)getValueWithBasePointResultKey:(NSString *)basePointResultKey {
    if (self.consultBasePoint.integerValue == 1) {
        if (!basePointResultKey.length) {
            return 0;
        }
    }
    else {
        basePointResultKey = PrismBehaviorDetectBasePointDefaultKey;
    }
    if ([self.type isEqualToString:@"same_person_number"]) {
        __block NSInteger count = 0;
        [self.currentValues enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
            count += obj.integerValue;
        }];
        return count;
    }
    else if ([self.type isEqualToString:@"same_item_number"]) {
        NSMutableDictionary *filterValues = [NSMutableDictionary dictionary];
        [self.currentValues enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
            NSRange keyRange = [key rangeOfString:[NSString stringWithFormat:@"%@-", basePointResultKey]];
            if (keyRange.length > 0 && keyRange.location == 0) {
                filterValues[key] = obj;
            }
        }];
        NSInteger maxValue = 0;
        for (NSNumber *number in filterValues.allValues) {
            if (number.integerValue > maxValue) {
                maxValue = number.integerValue;
            }
        }
        return maxValue;
    }
    else if ([self.type isEqualToString:@"same_person_date"]) {
        NSMutableArray *allDays = [NSMutableArray array];
        [self.currentDays enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableArray * _Nonnull obj, BOOL * _Nonnull stop) {
            for (NSString *beginningOfDayTimestamp in obj) {
                if (!beginningOfDayTimestamp.length) {
                    continue;
                }
                if (![allDays containsObject:beginningOfDayTimestamp]) {
                    [allDays addObject:beginningOfDayTimestamp];
                }
            }
        }];
        return allDays.count;
    }
    else if ([self.type isEqualToString:@"same_item_date"]) {
        NSMutableDictionary *filterValues = [NSMutableDictionary dictionary];
        [self.currentDays enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableArray * _Nonnull obj, BOOL * _Nonnull stop) {
            NSRange keyRange = [key rangeOfString:[NSString stringWithFormat:@"%@-", basePointResultKey]];
            if (keyRange.length > 0 && keyRange.location == 0) {
                filterValues[key] = obj;
            }
        }];
        NSInteger maxValue = 0;
        for (NSMutableArray *array in filterValues.allValues) {
            if (array.count > maxValue) {
                maxValue = array.count;
            }
        }
        return maxValue;
    }
    else if ([self.type isEqualToString:@"same_person_category"]) {
        return self.currentValues.allKeys.count;
    }
    return 0;
}

- (void)plusValueWithInstructionFormatter:(PrismInstructionFormatter*)instructionFormatter
                               withParams:(NSDictionary *)params
                         withBasePointKey:(NSString *)basePointKey {
    if (self.consultBasePoint.integerValue <= 0 || !basePointKey.length) {
        basePointKey = PrismBehaviorDetectBasePointDefaultKey;
    }
    NSString *vrContent = [instructionFormatter instructionFragmentContentWithType:PrismInstructionFragmentTypeViewRepresentativeContent];
    NSString *itemName = [params prism_stringForKey:@"itemName"];
    basePointKey = [NSString stringWithFormat:@"%@-%@-%@", basePointKey, vrContent ? : @"", itemName ? : @""];
    
    if ([self.currentValues.allKeys containsObject:basePointKey]) {
        self.currentValues[basePointKey] = [NSNumber numberWithInteger:(self.currentValues[basePointKey].integerValue + 1)];
    }
    else {
        self.currentValues[basePointKey] = @1;
    }
    
    NSString *beginningOfDayTimestamp = [params prism_stringForKey:@"beginningOfDayTimestamp"];
    if (beginningOfDayTimestamp.length) {
        if ([self.currentDays.allKeys containsObject:basePointKey]) {
            if (![self.currentDays[basePointKey] containsObject:beginningOfDayTimestamp]) {
                [self.currentDays[basePointKey] addObject:beginningOfDayTimestamp];
            }
        }
        else {
            self.currentDays[basePointKey] = [NSMutableArray arrayWithArray:@[beginningOfDayTimestamp]];
        }
    }
}

#pragma mark - setters

#pragma mark - getters
- (NSMutableDictionary<NSString *,NSNumber *> *)currentValues {
    if (!_currentValues) {
        _currentValues = [NSMutableDictionary dictionary];
    }
    return _currentValues;
}

- (NSMutableDictionary<NSString *,NSMutableArray *> *)currentDays {
    if (!_currentDays) {
        _currentDays = [NSMutableDictionary dictionary];
    }
    return _currentDays;
}
@end


#pragma mark - PrismBehaviorDetectRuleRelationModel
@interface PrismBehaviorDetectRuleRelationModel()

@end

@implementation PrismBehaviorDetectRuleRelationModel
#pragma mark - life cycle

#pragma mark - public method
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

- (PrismBehaviorDetectRuleExpressionModel*)searchBasePointModel {
    PrismBehaviorDetectRuleExpressionModel *result = nil;
    for (NSObject *rule in self.rules) {
        if ([rule isKindOfClass:[PrismBehaviorDetectRuleRelationModel class]]) {
            result = [(PrismBehaviorDetectRuleRelationModel*)rule searchBasePointModel];
        }
        else if ([rule isKindOfClass:[PrismBehaviorDetectRuleExpressionModel class]]) {
            result = [(PrismBehaviorDetectRuleExpressionModel*)rule searchBasePointModel];
        }
        if (result) {
            return result;
        }
    }
    return result;
}

- (BOOL)isEstablishedWithBasePointResultKey:(NSString *)basePointResultKey {
    BOOL isEstablished = [self.relation isEqualToString:@"and"] ? YES : NO;
    for (NSObject *rule in self.rules) {
        BOOL isRuleEstablished = NO;
        if ([rule isKindOfClass:[PrismBehaviorDetectRuleRelationModel class]]) {
            isRuleEstablished = [(PrismBehaviorDetectRuleRelationModel*)rule isEstablishedWithBasePointResultKey:basePointResultKey];
        }
        else if ([rule isKindOfClass:[PrismBehaviorDetectRuleExpressionModel class]]) {
            isRuleEstablished = [(PrismBehaviorDetectRuleExpressionModel*)rule isEstablishedWithBasePointResultKey:basePointResultKey];
        }
        if ([self.relation isEqualToString:@"and"]) {
            isEstablished = isEstablished && isRuleEstablished;
            if (!isEstablished) {
                return NO;
            }
        }
        else if ([self.relation isEqualToString:@"or"]) {
            isEstablished = isEstablished || isRuleEstablished;
            if (isEstablished) {
                return YES;
            }
        }
    }
    return isEstablished;
}

- (NSString *)feedInstructionFormatter:(PrismInstructionFormatter *)instructionFormatter
                            withParams:(NSDictionary *)params
                      withBasePointKey:(NSString *)basePointKey {
    NSString *result = nil;
    for (NSObject *rule in self.rules) {
        if ([rule isKindOfClass:[PrismBehaviorDetectRuleRelationModel class]]) {
            result = [(PrismBehaviorDetectRuleRelationModel*)rule feedInstructionFormatter:instructionFormatter withParams:params withBasePointKey:basePointKey] ? : result;
        }
        else if ([rule isKindOfClass:[PrismBehaviorDetectRuleExpressionModel class]]) {
            result =  [(PrismBehaviorDetectRuleExpressionModel*)rule feedInstructionFormatter:instructionFormatter withParams:params withBasePointKey:basePointKey] ? : result;
        }
    }
    return result;
}

- (void)reset {
    for (NSObject *rule in self.rules) {
        if ([rule isKindOfClass:[PrismBehaviorDetectRuleRelationModel class]]) {
            [(PrismBehaviorDetectRuleRelationModel*)rule reset];
        }
        else if ([rule isKindOfClass:[PrismBehaviorDetectRuleExpressionModel class]]) {
            [(PrismBehaviorDetectRuleExpressionModel*)rule reset];
        }
    }
}

#pragma mark - private method

#pragma mark - setters
- (void)setRules:(NSArray *)rules {
    NSMutableArray *newRules = [NSMutableArray array];
    for (NSDictionary *rule in rules) {
        if ([rule.allKeys containsObject:@"relation"] && [rule.allKeys containsObject:@"rules"]) {
            NSError *relationError;
            PrismBehaviorDetectRuleRelationModel *relationModel = [[PrismBehaviorDetectRuleRelationModel alloc] initWithDictionary:rule error:&relationError];
            if (!relationError && relationModel) {
                [newRules addObject:relationModel];
            }
        }
        else {
            NSError *expressionError;
            PrismBehaviorDetectRuleExpressionModel *expressionModel = [[PrismBehaviorDetectRuleExpressionModel alloc] initWithDictionary:rule error:&expressionError];
            if (!expressionError && expressionModel) {
                [newRules addObject:expressionModel];
            }
        }
    }
    _rules = [newRules copy];
}

#pragma mark - getters

@end


#pragma mark - PrismBehaviorDetectRuleModel
@interface PrismBehaviorDetectRuleModel()

@end

@implementation PrismBehaviorDetectRuleModel
#pragma mark - life cycle

#pragma mark - public method
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

- (BOOL)isEstablishedWithCityId:(NSNumber *)cityId {
    BOOL isEstablished = YES;
    if (self.cityId.integerValue > 0) {
        isEstablished = isEstablished && self.cityId.integerValue == cityId.integerValue;
    }
    PrismBehaviorDetectRuleExpressionModel *basePointModel = [self.ruleContent searchBasePointModel];
    if (basePointModel) {
        isEstablished = isEstablished && [basePointModel isEstablishedWithBasePointResultKey:self.lastBasePointKey];
        if (!isEstablished) {
            return NO;
        }
        if (self.lastBasePointKey.length && ![self.basePointResultKeys containsObject:self.lastBasePointKey]) {
            [self.basePointResultKeys addObject:self.lastBasePointKey];
        }
        if (self.triggerMoment.integerValue == 1 &&
            (self.isLastInstructionEffective == NO || [self.basePointResultKeys containsObject:self.lastBasePointKey] == NO)) {
            return NO;
        }
    }
    isEstablished = isEstablished && [self.ruleContent isEstablishedWithBasePointResultKey:self.lastBasePointKey];
    return isEstablished;
}

- (void)feedInstructionFormatter:(PrismInstructionFormatter *)instructionFormatter withParams:(NSDictionary *)params {
    NSString *result = [self.ruleContent feedInstructionFormatter:instructionFormatter
                                                       withParams:params
                                                 withBasePointKey:self.lastBasePointKey];
    self.isLastInstructionEffective = result.length;
    if (result.length) {
        self.lastBasePointKey = result;
    }
}

- (void)reset {
    [self.ruleContent reset];
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters
- (NSMutableArray<NSString *> *)basePointResultKeys {
    if (!_basePointResultKeys) {
        _basePointResultKeys = [NSMutableArray array];
    }
    return _basePointResultKeys;
}
@end


#pragma mark - PrismBehaviorDetectRuleConfigModel
@interface PrismBehaviorDetectRuleConfigModel()

@end

@implementation PrismBehaviorDetectRuleConfigModel
#pragma mark - life cycle

#pragma mark - public method
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

- (NSArray<PrismBehaviorDetectRuleModel*>*)detectRuleWithCityId:(NSNumber*)cityId {
    NSMutableArray<PrismBehaviorDetectRuleModel *> *hitRules = [NSMutableArray array];
    NSMutableArray<PrismBehaviorDetectRuleModel *> *needRemoveRules = [NSMutableArray array];
    for (PrismBehaviorDetectRuleModel *ruleModel in self.rules) {
        if ([ruleModel isEstablishedWithCityId:cityId]) {
            [hitRules addObject:ruleModel];
            if (ruleModel.cycleTrigger.integerValue == 1) {
                [ruleModel reset];
            }
            else {
                [needRemoveRules addObject:ruleModel];
            }
        }
    }
    // 移除已命中且需要移除的策略。
    NSMutableArray *mutableRules = [self.rules mutableCopy];
    for (PrismBehaviorDetectRuleModel *ruleModel in needRemoveRules) {
        [mutableRules removeObject:ruleModel];
    }
    self.rules = [mutableRules copy];
    return [hitRules copy];
}

- (void)feedInstructionFormatter:(PrismInstructionFormatter *)instructionFormatter withParams:(NSDictionary *)params {
    for (PrismBehaviorDetectRuleModel *ruleModel in self.rules) {
        [ruleModel feedInstructionFormatter:instructionFormatter withParams:params];
    }
}

- (void)setupWithLoader:(NSArray<NSDictionary*>*(^)(NSInteger))loader {
    for (PrismBehaviorDetectRuleModel *ruleModel in self.rules) {
        if (ruleModel.period.integerValue <= 0) {
            continue;
        }
        NSDate *effectiveDay = [NSDate dateWithTimeIntervalSince1970:ruleModel.effectiveTime.doubleValue];
        NSDate *today = [[NSDate date] prism_beginningOfDay];
        NSInteger period = ruleModel.period.integerValue;
        NSInteger effectiveDays = [effectiveDay prism_daysBeforeDate:today] + 1;
        NSInteger daysCount = 0;
        if (effectiveDays >= period || ruleModel.containHistory.integerValue == 1) {
            // period
            daysCount = period;
        }
        else {
            // effectiveDays
            daysCount = effectiveDays;
        }
        if (loader) {
            NSArray<NSDictionary*> *historyBehaviors = loader(daysCount);
            for (NSDictionary *historyBehavior in historyBehaviors) {
                NSString *instruction = [historyBehavior prism_stringForKey:@"instruction"];
                NSDictionary *params = [historyBehavior prism_dictionaryForKey:@"params"];
                NSString *currentTimestamp = [params prism_stringForKey:@"currentTimestamp"];
                if (!instruction.length || (currentTimestamp.length && currentTimestamp.doubleValue <= ruleModel.effectiveTime.doubleValue)) {
                    continue;
                }
                PrismInstructionFormatter *instructionFormatter = [[PrismInstructionFormatter alloc] initWithInstruction:instruction];
                [ruleModel feedInstructionFormatter:instructionFormatter withParams:params];
            }
        }
    }
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end


