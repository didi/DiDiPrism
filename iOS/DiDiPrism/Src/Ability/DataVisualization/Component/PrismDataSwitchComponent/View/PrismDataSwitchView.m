//
//  PrismDataSwitchView.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/23.
//

#import "PrismDataSwitchView.h"
#import "Masonry.h"
#import "PrismIdentifierUtil.h"
// Category
#import "UIButton+PrismExtends.h"

@interface PrismDataSwitchView()
@property (nonatomic, strong) UIButton *leftModeButton;
@property (nonatomic, strong) UIButton *rightModeButton;
@end

@implementation PrismDataSwitchView
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
- (void)leftModeAction:(UIButton*)sender {
    if (sender.isSelected) {
        return;
    }
    [sender setSelected:YES];
    [self.rightModeButton setSelected:NO];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchLeftModeButton:)]) {
        [self.delegate didTouchLeftModeButton:sender];
    }
}

- (void)rightModeAction:(UIButton*)sender {
    if (sender.isSelected) {
        return;
    }
    [sender setSelected:YES];
    [self.leftModeButton setSelected:NO];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchRightModeButton:)]) {
        [self.delegate didTouchRightModeButton:sender];
    }
}

#pragma mark - delegate

#pragma mark - override method

#pragma mark - public method

#pragma mark - private method
- (void)initView {
    self.accessibilityIdentifier = [PrismIdentifierUtil identifier];
    self.backgroundColor = [UIColor colorWithRed:0.01 green:0.03 blue:0.08 alpha:0.8];
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.cornerRadius = PrismDataSwitchViewHeight / 2;
    self.layer.masksToBounds = YES;
    
    [self.leftModeButton setSelected:YES];
    [self addSubview:self.leftModeButton];
    [self addSubview:self.rightModeButton];
    
    [self.leftModeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(3);
        make.bottom.equalTo(self).offset(-3);
        make.right.equalTo(self.mas_centerX);
    }];
    [self.rightModeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(3);
        make.right.bottom.equalTo(self).offset(-3);
        make.left.equalTo(self.mas_centerX);
    }];
}

#pragma mark - setters

#pragma mark - getters
- (UIButton *)leftModeButton {
    if (!_leftModeButton) {
        _leftModeButton = [[UIButton alloc] init];
        _leftModeButton.accessibilityLabel = [PrismIdentifierUtil identifier];
        _leftModeButton.layer.cornerRadius = (PrismDataSwitchViewHeight - 6) / 2;
        _leftModeButton.layer.masksToBounds = YES;
        _leftModeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_leftModeButton setTitle:@"看数据" forState:UIControlStateNormal];
        [_leftModeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftModeButton setTitleColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0] forState:UIControlStateSelected];
        [_leftModeButton prism_setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_leftModeButton prism_setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_leftModeButton addTarget:self action:@selector(leftModeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftModeButton;
}

- (UIButton *)rightModeButton {
    if (!_rightModeButton) {
        _rightModeButton = [[UIButton alloc] init];
        _rightModeButton.accessibilityLabel = [PrismIdentifierUtil identifier];
        _rightModeButton.layer.cornerRadius = (PrismDataSwitchViewHeight - 6) / 2;
        _rightModeButton.layer.masksToBounds = YES;
        _rightModeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_rightModeButton setTitle:@"看热力" forState:UIControlStateNormal];
        [_rightModeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightModeButton setTitleColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0] forState:UIControlStateSelected];
        [_rightModeButton prism_setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_rightModeButton prism_setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_rightModeButton addTarget:self action:@selector(rightModeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightModeButton;
}

@end
