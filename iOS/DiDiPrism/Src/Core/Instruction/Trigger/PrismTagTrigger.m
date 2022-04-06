//
//  PrismTagTrigger.m
//  DiDiPrism
//
//  Created by hulk on 2022/3/17.
//

#import "PrismTagTrigger.h"

@interface PrismTagTrigger()

@end

@implementation PrismTagTrigger
#pragma mark - life cycle

#pragma mark - public method
- (void)triggerWithElement:(NSObject *)element withNewValue:(id)newValue withDelay:(NSTimeInterval)delaySeconds {
    NSString *text = (NSString*)element;
    UILabel *promptLabel = [[UILabel alloc] init];
    [self showPromptView:promptLabel withText:text];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [promptLabel removeFromSuperview];
    });
}

#pragma mark - private method
- (void)showPromptView:(UILabel*)promptLabel withText:(NSString*)text {
    UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
    promptLabel.font = [UIFont boldSystemFontOfSize:35];
    promptLabel.textColor = [UIColor redColor];
    promptLabel.text = text;
    [promptLabel sizeToFit];
    promptLabel.frame = CGRectMake((mainWindow.frame.size.width - promptLabel.frame.size.width)/2, (mainWindow.frame.size.height - promptLabel.frame.size.height)/2, promptLabel.frame.size.width, promptLabel.frame.size.height);
    [mainWindow addSubview:promptLabel];
}

#pragma mark - setters

#pragma mark - getters

@end
