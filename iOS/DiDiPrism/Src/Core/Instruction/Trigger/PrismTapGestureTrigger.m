//
//  PrismTapGestureTrigger.m
//  DiDiPrism
//
//  Created by didi on 2022/3/17.
//

#import "PrismTapGestureTrigger.h"

@interface PrismTapGestureTrigger()

@end

@implementation PrismTapGestureTrigger
#pragma mark - life cycle

#pragma mark - public method
- (void)triggerWithElement:(NSObject *)element withNewValue:(id)newValue withDelay:(NSTimeInterval)delaySeconds {
    if (!element) {
        return;
    }
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer*)element;
    [self highlightTheElement:tapGesture.view withNewColor:newValue withDelay:delaySeconds withCompletion:^{
        [tapGesture setState:UIGestureRecognizerStateRecognized];
    }];
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
