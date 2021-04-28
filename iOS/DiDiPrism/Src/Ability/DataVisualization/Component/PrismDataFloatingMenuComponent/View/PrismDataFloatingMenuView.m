//
//  PrismDataFloatingMenuView.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/23.
//

#import "PrismDataFloatingMenuView.h"
#import "PrismIdentifierUtil.h"

#define PrismDataFloatingMenuViewWidth 130
#define PrismDataFloatingMenuItemHeight 40

@interface PrismDataFloatingMenuView()
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, assign) CGFloat currentOrignX;
@end

@implementation PrismDataFloatingMenuView
#pragma mark - life cycle
- (instancetype)init {
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - action
- (void)tapAction:(UITapGestureRecognizer*)gesture {
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchNothing)]) {
        [self.delegate didTouchNothing];
    }
}

- (void)tapButtonAction:(UIButton*)sender {
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchButtonWithIndex:)]) {
        [self.delegate didTouchButtonWithIndex:sender.tag - 100];
    }
}

#pragma mark - delegate

#pragma mark - public method
- (void)addMenuItemWithIndex:(NSInteger)index withTitle:(NSString *)title withImage:(UIImage*)image {
    UIButton *button = [self generateButtonWithTitle:title withImage:image];
    button.tag = 100 + index;
    button.frame = CGRectMake(0, self.currentOrignX, PrismDataFloatingMenuViewWidth, PrismDataFloatingMenuItemHeight);
    [self.backgroundView addSubview:button];
    self.currentOrignX += PrismDataFloatingMenuItemHeight;
}

- (void)reloadWithReferView:(UIView*)referView {
    UIWindow *mainWindow = UIApplication.sharedApplication.delegate.window;
    CGPoint elementCenter = [referView convertPoint:referView.center toView:mainWindow];
    CGRect elementRect = [referView convertRect:referView.bounds toView:mainWindow];
    CGRect mainScreenRect = [UIScreen mainScreen].bounds;
    CGPoint mainScreenCenter = CGPointMake(mainScreenRect.origin.x + mainScreenRect.size.width / 2, mainScreenRect.origin.y + mainScreenRect.size.height / 2);
    // frame
    CGFloat height = self.backgroundView.subviews.count * PrismDataFloatingMenuItemHeight;
    CGFloat orignX = elementCenter.x <= mainScreenCenter.x || elementRect.size.width > mainScreenRect.size.width * 3 / 5 ? elementRect.origin.x : elementRect.origin.x + elementRect.size.width - PrismDataFloatingMenuViewWidth;
    CGFloat orignY = elementCenter.y <= mainScreenCenter.y ? elementRect.origin.y + elementRect.size.height + 5 : elementRect.origin.y - height - 5;
    self.backgroundView.frame = CGRectMake(orignX, orignY, PrismDataFloatingMenuViewWidth, height);
}

#pragma mark - private method
- (void)initView {
    self.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapGesture.accessibilityLabel = [PrismIdentifierUtil identifier];
    [self addGestureRecognizer:tapGesture];
    
    [self addSubview:self.backgroundView];
}

- (UIButton*)generateButtonWithTitle:(NSString*)title withImage:(UIImage*)image {
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:[NSString stringWithFormat:@"%@        ", title] forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    if (@available(iOS 9.0, *)) {
        button.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    }
    [button addTarget:self action:@selector(tapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - setters

#pragma mark - getters
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor colorWithRed:0.01 green:0.03 blue:0.08 alpha:0.8];
        _backgroundView.layer.cornerRadius = 5.0f;
        _backgroundView.layer.masksToBounds = YES;
    }
    return _backgroundView;
}

@end
