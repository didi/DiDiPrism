//
//  PrismBehaviorDetectManager.m
//  DiDiPrism
//
//  Created by hulk on 2020/9/29.
//

#import "PrismBehaviorDetectManager.h"
#import <DiDiPrism/PrismInstructionFormatter.h>
#import <DiDiPrism/NSDate+PrismExtends.h>
#import "PrismBehaviorStorageManager.h"

@interface PrismBehaviorDetectManager()
@property (nonatomic, strong) PrismBehaviorDetectRuleConfigModel *ruleConfigModel;
@end

@implementation PrismBehaviorDetectManager
#pragma mark - life cycle
+ (instancetype)sharedInstance {
    static PrismBehaviorDetectManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PrismBehaviorDetectManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - public method
- (void)setupWithConfigModel:(PrismBehaviorDetectRuleConfigModel*)configModel {
    if (!configModel) {
        return;
    }
    self.ruleConfigModel = configModel;
    dispatch_async([[PrismBehaviorStorageManager sharedInstance] workQueue], ^{
        [self.ruleConfigModel setupWithLoader:^NSArray<NSDictionary *> * _Nonnull(NSInteger daysCount) {
            return [[PrismBehaviorStorageManager sharedInstance] readFileOfDays:daysCount];
        }];
    });
}

- (void)addInstruction:(NSString*)instruction withParams:(NSDictionary*)params {
    if (!instruction.length) {
        return;
    }
    if (!self.ruleConfigModel) {
        return;
    }
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    newParams[@"beginningOfDayTimestamp"] = [NSString stringWithFormat:@"%.0f", [[[NSDate date] prism_beginningOfDay] timeIntervalSince1970]];
    newParams[@"currentTimestamp"] = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    params = [newParams copy];
    dispatch_async([[PrismBehaviorStorageManager sharedInstance] workQueue], ^{
        [[PrismBehaviorStorageManager sharedInstance] addInstruction:instruction withParams:params];
        PrismInstructionFormatter *instructionFormatter = [[PrismInstructionFormatter alloc] initWithInstruction:instruction];
        [self.ruleConfigModel feedInstructionFormatter:instructionFormatter withParams:params];
        NSNumber *cityId = [NSNumber numberWithInteger:0];
        NSArray<PrismBehaviorDetectRuleModel*> *hitRules = [self.ruleConfigModel detectRuleWithCityId:cityId];
        if (hitRules.count) {
            for (PrismBehaviorDetectRuleModel* ruleModel in hitRules) {
                NSInteger triggerDelay = ruleModel.triggerDelay.integerValue;
                NSNumber *ruleId = ruleModel.ruleId;
                if (triggerDelay < 0) {
                    triggerDelay = 0;
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(triggerDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (ruleId) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"prism_behavior_detect_rule_hit" object:nil userInfo:@{@"ruleId":ruleId.stringValue}];
                    }
                });
            }
        }
    });
}

#pragma mark - private method

#pragma mark - actions

#pragma mark - setters

#pragma mark - getters

@end
