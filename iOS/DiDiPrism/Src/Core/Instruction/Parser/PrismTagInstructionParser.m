//
//  PrismTagInstructionParser.m
//  DiDiPrism
//
//  Created by hulk on 2019/10/15.
//

#import "PrismTagInstructionParser.h"
#import "PrismInstructionDefines.h"

@interface PrismTagInstructionParser()

@end

@implementation PrismTagInstructionParser
#pragma mark - life cycle

#pragma mark - public method
- (PrismInstructionParseResult)parseWithFormatter:(PrismInstructionFormatter *)formatter {
    if ([formatter.instruction isEqualToString:kUIApplicationBecomeActive]) {
        UILabel *promptLabel = [[UILabel alloc] init];
        [self showPromptView:promptLabel withText:@"回到前台"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [promptLabel removeFromSuperview];
        });
        return PrismInstructionParseResultSuccess;
    }
    else if ([formatter.instruction isEqualToString:kUIApplicationResignActive]) {
        UILabel *promptLabel = [[UILabel alloc] init];
        [self showPromptView:promptLabel withText:@"切到后台"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [promptLabel removeFromSuperview];
        });
        return PrismInstructionParseResultSuccess;
    }
    return PrismInstructionParseResultError;
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
