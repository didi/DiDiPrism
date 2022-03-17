//
//  PrismControlTrigger.m
//  DiDiPrism
//
//  Created by hulk on 2022/3/17.
//

#import "PrismControlTrigger.h"

@interface PrismControlTrigger()

@end

@implementation PrismControlTrigger
#pragma mark - life cycle

#pragma mark - public method
- (void)triggerWithElement:(NSObject *)element withDelay:(NSTimeInterval)delaySeconds {
    if (!element) {
        return;
    }
    UIControl *targetControl = element;
    [self highlightTheElement:targetControl withDelay:delaySeconds withCompletion:^{
        [targetControl sendActionsForControlEvents:UIControlEventAllTouchEvents];
    }];
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
