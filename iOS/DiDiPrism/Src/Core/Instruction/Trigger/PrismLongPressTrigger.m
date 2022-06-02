//
//  PrismLongPressTrigger.m
//  DiDiPrism
//
//  Created by didi on 2022/3/17.
//

#import "PrismLongPressTrigger.h"

@interface PrismLongPressTrigger()

@end

@implementation PrismLongPressTrigger
#pragma mark - life cycle

#pragma mark - public method
- (void)triggerWithElement:(NSObject *)element withNewValue:(id)newValue withDelay:(NSTimeInterval)delaySeconds {
    if (!element) {
        return;
    }
    UILongPressGestureRecognizer *longPressGesture = (UILongPressGestureRecognizer*)element;
    [self highlightTheElement:longPressGesture.view withNewColor:newValue withDelay:delaySeconds withCompletion:^{
        [longPressGesture setState:UIGestureRecognizerStateRecognized];
    }];
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
