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
        event == PrismDispatchEventUIControlTouchAction ||
        event == PrismDispatchEventUITapGestureRecognizerAction) {
        
        PrismDataBubbleModel *model = [[PrismDataBubbleModel alloc] init];
        model.content = [NSString stringWithFormat:@"%f", random()];
        model.promptTitle = @"页面停留时长";
        self.bubbleView.model = model;
        
        if (self.dataProvider && [self.dataProvider respondsToSelector:@selector(provideDataWithParams:withCompletion:)]) {
            [self.dataProvider provideDataWithParams:nil withCompletion:^(PrismDataBaseModel * _Nonnull model) {
                if (![model isKindOfClass:[PrismDataBubbleModel class]]) {
                    return;
                }
                PrismDataBubbleModel *result = (PrismDataBubbleModel*)model;
            }];
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
