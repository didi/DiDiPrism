//
//  PrismTextFieldTrigger.m
//  DiDiPrism
//
//  Created by hulk on 2022/4/6.
//

#import "PrismTextFieldTrigger.h"

@interface PrismTextFieldTrigger()

@end

@implementation PrismTextFieldTrigger
#pragma mark - life cycle

#pragma mark - public method
- (void)triggerWithElement:(NSObject *)element withNewValue:(id)newValue withDelay:(NSTimeInterval)delaySeconds {
    UITextField *textField = (UITextField*)element;
    [self highlightTheElement:textField withNewColor:[UIColor redColor] withDelay:delaySeconds withCompletion:^{
        textField.text = newValue;
        [textField endEditing:YES];
    }];
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
