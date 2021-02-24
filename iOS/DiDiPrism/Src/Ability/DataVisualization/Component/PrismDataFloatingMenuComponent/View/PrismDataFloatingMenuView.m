//
//  PrismDataFloatingMenuView.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/23.
//

#import "PrismDataFloatingMenuView.h"
#import "PrismIdentifierUtil.h"

@interface PrismDataFloatingMenuView()
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIButton *clickTypeButton;
@property (nonatomic, strong) UIButton *exposureTypeButton;
@property (nonatomic, strong) UIButton *funnelButton;
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

- (void)funnelAction:(UIButton*)sender {
    [self removeFromSuperview];
    
}

- (void)exposureTypeAction:(UIButton*)sender {
    [self removeFromSuperview];
    
}

- (void)clickTypeAction:(UIButton*)sender {
    [self removeFromSuperview];
    
}

#pragma mark - delegate

#pragma mark - public method
- (void)reload {

    BOOL hasFunnel = YES;
    
    UIWindow *mainWindow = UIApplication.sharedApplication.delegate.window;
    CGFloat orignX = 100, orignY = 100, width = 130, height = 120;
    CGRect mainScreenRect = [UIScreen mainScreen].bounds;
    CGPoint mainScreenCenter = CGPointMake(mainScreenRect.origin.x + mainScreenRect.size.width / 2, mainScreenRect.origin.y + mainScreenRect.size.height / 2);
    
    // frame
    self.backgroundView.frame = CGRectMake(orignX, orignY, width, height);
    
    CGFloat currentOrignX = 0;
    
        [self.backgroundView addSubview:self.clickTypeButton];
        self.clickTypeButton.frame = CGRectMake(0, currentOrignX, width, 40);
        currentOrignX += 40;
    
    
        [self.backgroundView addSubview:self.exposureTypeButton];
        self.exposureTypeButton.frame = CGRectMake(0, currentOrignX, width, 40);
        currentOrignX += 40;
    
    
        [self.backgroundView addSubview:self.funnelButton];
        self.funnelButton.frame = CGRectMake(0, currentOrignX, width, 40);
    
    
}

#pragma mark - private method
- (void)initView {
    self.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapGesture.accessibilityLabel = [PrismIdentifierUtil identifier];
    [self addGestureRecognizer:tapGesture];
    
    [self addSubview:self.backgroundView];
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

- (UIButton *)clickTypeButton {
    if (!_clickTypeButton) {
        _clickTypeButton = [[UIButton alloc] init];
        _clickTypeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_clickTypeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_clickTypeButton setTitle:@"点击详情        " forState:UIControlStateNormal];
//        [_clickTypeButton setImage:[EDImageUtil imageNamed:@"easydot_data_operate_click"] forState:UIControlStateNormal];
        if (@available(iOS 9.0, *)) {
            _clickTypeButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
        }
        [_clickTypeButton addTarget:self action:@selector(clickTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickTypeButton;
}

- (UIButton *)exposureTypeButton {
    if (!_exposureTypeButton) {
        _exposureTypeButton = [[UIButton alloc] init];
        _exposureTypeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_exposureTypeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_exposureTypeButton setTitle:@"曝光详情        " forState:UIControlStateNormal];
//        [_exposureTypeButton setImage:[EDImageUtil imageNamed:@"easydot_data_operate_exposure"] forState:UIControlStateNormal];
        if (@available(iOS 9.0, *)) {
            _exposureTypeButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
        }
        [_exposureTypeButton addTarget:self action:@selector(exposureTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exposureTypeButton;
}

- (UIButton *)funnelButton {
    if (!_funnelButton) {
        _funnelButton = [[UIButton alloc] init];
        _funnelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_funnelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_funnelButton setTitle:@"转化漏斗        " forState:UIControlStateNormal];
//        [_funnelButton setImage:[EDImageUtil imageNamed:@"easydot_data_operate_funnel"] forState:UIControlStateNormal];
        if (@available(iOS 9.0, *)) {
            _funnelButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
        }
        [_funnelButton addTarget:self action:@selector(funnelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _funnelButton;
}

@end
