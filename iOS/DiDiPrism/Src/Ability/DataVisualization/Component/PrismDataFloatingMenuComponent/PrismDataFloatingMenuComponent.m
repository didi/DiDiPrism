//
//  PrismDataFloatingMenuComponent.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/23.
//

#import "PrismDataFloatingMenuComponent.h"
#import "UIView+PrismDataVisualization.h"
// View
#import "PrismDataFloatingMenuView.h"

@interface PrismDataFloatingMenuComponent() <PrismDataFloatingMenuViewDelegate>
@property (nonatomic, strong) PrismDataFloatingMenuView *menuView;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, assign) BOOL isMenuViewShowing;
@property (nonatomic, copy) NSArray<PrismDataFloatingMenuItemConfig *> *menuItemConfig;
@property (nonatomic, weak) UIView *touchedView;
@end

@implementation PrismDataFloatingMenuComponent
#pragma mark - life cycle

#pragma mark - public method
- (void)setupWithConfig:(NSArray<PrismDataFloatingMenuItemConfig *> *)config {
    if (!config.count) {
        return;
    }
    self.menuItemConfig = config;
    for (PrismDataFloatingMenuItemConfig *itemConfig in config) {
        [self.menuView addMenuItemWithIndex:itemConfig.index withTitle:itemConfig.name withImage:itemConfig.image];
    }
}

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
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(matchViewWithTapGesture:)]) {
        self.touchedView = [(id<PrismDataFloatingMenuComponentDelegate>)self.delegate matchViewWithTapGesture:gesture];
    }
    [self.menuView reloadWithReferView:self.touchedView];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuDidAppearWithTouchedView:)]) {
        [(id<PrismDataFloatingMenuComponentDelegate>)self.delegate menuDidAppearWithTouchedView:self.touchedView];
    }
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [feedBackGenertor impactOccurred];
    }
}

#pragma mark - delegate
#pragma mark PrismDataFloatingMenuViewDelegate
- (void)didTouchNothing {
    self.isMenuViewShowing = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuDidDisappearWithTouchedView:)]) {
        [(id<PrismDataFloatingMenuComponentDelegate>)self.delegate menuDidDisappearWithTouchedView:self.touchedView];
    }
}

- (void)didTouchButtonWithIndex:(NSInteger)index {
    self.isMenuViewShowing = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuDidDisappearWithTouchedView:)]) {
        [(id<PrismDataFloatingMenuComponentDelegate>)self.delegate menuDidDisappearWithTouchedView:self.touchedView];
    }
    for (PrismDataFloatingMenuItemConfig *itemConfig in self.menuItemConfig) {
        if (itemConfig.index == index && itemConfig.block) {
            itemConfig.block(self.touchedView);
        }
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
        _menuView.delegate = self;
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
