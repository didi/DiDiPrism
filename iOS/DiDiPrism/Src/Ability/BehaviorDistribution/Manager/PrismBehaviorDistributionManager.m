//
//  PrismBehaviorDistributionManager.m
//  DiDiPrism
//
//  Created by hulk on 2021/5/11.
//

#import "PrismBehaviorDistributionManager.h"

@interface PrismBehaviorDistributionManager()

@end

@implementation PrismBehaviorDistributionManager
#pragma mark - life cycle
+ (instancetype)sharedInstance {
    static PrismBehaviorDistributionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PrismBehaviorDistributionManager alloc] init];
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

#pragma mark - private method

#pragma mark - actions

#pragma mark - setters

#pragma mark - getters

@end
