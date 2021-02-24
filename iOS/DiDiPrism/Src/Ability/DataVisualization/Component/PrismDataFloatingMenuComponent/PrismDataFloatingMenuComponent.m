//
//  PrismDataFloatingMenuComponent.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/23.
//

#import "PrismDataFloatingMenuComponent.h"
// View
#import "PrismDataFloatingMenuView.h"

@interface PrismDataFloatingMenuComponent()
@property (nonatomic, strong) PrismDataFloatingMenuView *menuView;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, assign) BOOL isMenuViewShowing;
@end

@implementation PrismDataFloatingMenuComponent
#pragma mark - life cycle

#pragma mark - public method

#pragma mark - private method

#pragma mark - action
- (void)longPressAction:(UILongPressGestureRecognizer*)gesture {
    if (self.isMenuViewShowing) {
        return;
    }
    if (gesture.state != UIGestureRecognizerStateBegan) {
        return;
    }
    self.isMenuViewShowing = YES;
    UIWindow *mainWindow = UIApplication.sharedApplication.delegate.window;
    self.menuView.frame = mainWindow.bounds;
    [mainWindow addSubview:self.menuView];
    [self.menuView reload];
    
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [feedBackGenertor impactOccurred];
    }
}

#pragma mark - setters
- (void)setEnable:(BOOL)enable {
    [super setEnable:enable];
    UIWindow *mainWindow = UIApplication.sharedApplication.delegate.window;
    if (self.enable) {
        if (!self.longPressGesture.view) {
            [mainWindow addGestureRecognizer:self.longPressGesture];
        }
    }
    else {
        [mainWindow removeGestureRecognizer:self.longPressGesture];
    }
}

#pragma mark - getters
- (PrismDataFloatingMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[PrismDataFloatingMenuView alloc] init];
    }
    return _menuView;
}

- (UILongPressGestureRecognizer *)longPressGesture {
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    }
    return _longPressGesture;
}
@end
