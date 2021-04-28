//
//  PrismDataBubbleComponent.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import "PrismDataBubbleComponent.h"
// View
#import "PrismDataBubbleView.h"

@interface PrismDataBubbleComponent()
@property (nonatomic, strong) PrismDataBubbleView *bubbleView;
@end

@implementation PrismDataBubbleComponent
#pragma mark - life cycle

#pragma mark - public method
- (void)dispatchEvent:(PrismDispatchEvent)event withSender:(NSObject *)sender params:(NSDictionary *)params {
    if (event == PrismDispatchEventUIViewTouchesEnded_End ||
        event == PrismDispatchEventUIControlSendAction_Start ||
        event == PrismDispatchEventUITapGestureRecognizerAction) {
        
        UIViewController *mainViewController = [self _protected_searchMainViewController];
        if (mainViewController) {
            if (self.dataProvider && [self.dataProvider respondsToSelector:@selector(provideDataToComponent:withParams:withCompletion:)]) {
                __weak typeof(self) weakSelf = self;
                [self.dataProvider provideDataToComponent:self withParams:@{@"mainVC":mainViewController} withCompletion:^(PrismDataBaseModel * _Nonnull model) {
                    if (![model isKindOfClass:[PrismDataBubbleModel class]]) {
                        return;
                    }
                    weakSelf.bubbleView.model = (PrismDataBubbleModel*)model;
                }];
            }
        }
    }
}

#pragma mark - private method

#pragma mark - setters
- (void)setEnable:(BOOL)enable {
    [super setEnable:enable];
    
    if (self.enable) {
        UIWindow *mainWindow = UIApplication.sharedApplication.delegate.window;
        [mainWindow addSubview:self.bubbleView];
    }
    else {
        [self.bubbleView removeFromSuperview];
    }
}

#pragma mark - getters
- (PrismDataBubbleView *)bubbleView {
    if (!_bubbleView) {
        _bubbleView = [[PrismDataBubbleView alloc] initWithFrame:CGRectMake(10, 100, PrismDataBubbleViewFoldWidth, PrismDataBubbleViewHeight)];
    }
    return _bubbleView;
}
@end
