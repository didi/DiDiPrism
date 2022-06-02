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
    NSString *newText = newValue;
    [self highlightTheElement:textField withNewColor:[UIColor redColor] withDelay:delaySeconds withCompletion:^{
        textField.text = newText;
        [textField sendActionsForControlEvents:UIControlEventEditingChanged];
        if ([textField.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
            [textField.delegate textField:textField shouldChangeCharactersInRange:NSMakeRange(0, newText.length) replacementString:newText];
        }
    }];
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
