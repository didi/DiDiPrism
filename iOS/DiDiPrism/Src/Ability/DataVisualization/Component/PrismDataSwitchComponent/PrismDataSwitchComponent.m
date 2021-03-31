//
//  PrismDataSwitchComponent.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import "PrismDataSwitchComponent.h"
// View
#import "PrismDataSwitchView.h"

@interface PrismDataSwitchComponent()
@property (nonatomic, strong) PrismDataSwitchView *switchView;
@end

@implementation PrismDataSwitchComponent
#pragma mark - life cycle

#pragma mark - public method

#pragma mark - private method

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
    }
    return _switchView;
}

@end
