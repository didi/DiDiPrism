//
//  PrismDataSwitchComponent.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import "PrismDataSwitchComponent.h"
// View
#import "PrismDataSwitchView.h"

@interface PrismDataSwitchComponent() <PrismDataSwitchViewDelegate>
@property (nonatomic, strong) PrismDataSwitchView *switchView;
@end

@implementation PrismDataSwitchComponent
#pragma mark - life cycle

#pragma mark - public method

#pragma mark - private method

#pragma mark - delegate
#pragma mark PrismDataSwitchViewDelegate
- (void)didTouchDataModeButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchToMode:)]) {
        [(id<PrismDataSwitchComponentDelegate>)self.delegate switchToMode:PrismDataSwitchComponentDataMode];
    }
}

- (void)didTouchHeatModeButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchToMode:)]) {
        [(id<PrismDataSwitchComponentDelegate>)self.delegate switchToMode:PrismDataSwitchComponentHeatMode];
    }
}

#pragma mark - setters
- (void)setEnable:(BOOL)enable {
    [super setEnable:enable];
    
    if (self.enable) {
        UIWindow *mainWindow = UIApplication.sharedApplication.delegate.window;
        [mainWindow addSubview:self.switchView];
    }
    else {
        [self.switchView removeFromSuperview];
    }
}

#pragma mark - getters
- (PrismDataSwitchView *)switchView {
    if (!_switchView) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        _switchView = [[PrismDataSwitchView alloc] initWithFrame:CGRectMake(screenWidth - PrismDataSwitchViewWidth - 35, screenHeight - PrismDataSwitchViewHeight - 80, PrismDataSwitchViewWidth, PrismDataSwitchViewHeight)];
        _switchView.delegate = self;
    }
    return _switchView;
}

@end
