//
//  PrismDataSwitchView.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/23.
//

#import "PrismDataSwitchView.h"
#import <Masonry/Masonry.h>
#import <DiDiPrism/PrismIdentifierUtil.h>
// Category
#import <DiDiPrism/UIButton+PrismExtends.h>

@interface PrismDataSwitchView()
@property (nonatomic, strong) UIButton *dataModeButton;
@property (nonatomic, strong) UIButton *heatModeButton;
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
- (void)dataModeAction:(UIButton*)sender {
    if (sender.isSelected) {
        return;
    }
    [sender setSelected:YES];
    [self.heatModeButton setSelected:NO];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchDataModeButton:)]) {
        [self.delegate didTouchDataModeButton:sender];
    }
}

- (void)heatModeAction:(UIButton*)sender {
    if (sender.isSelected) {
        return;
    }
    [sender setSelected:YES];
    [self.dataModeButton setSelected:NO];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchHeatModeButton:)]) {
        [self.delegate didTouchHeatModeButton:sender];
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
    
    [self.dataModeButton setSelected:YES];
    [self addSubview:self.dataModeButton];
    [self addSubview:self.heatModeButton];
    
    [self.dataModeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(3);
        make.bottom.equalTo(self).offset(-3);
        make.right.equalTo(self.mas_centerX);
    }];
    [self.heatModeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(3);
        make.right.bottom.equalTo(self).offset(-3);
        make.left.equalTo(self.mas_centerX);
    }];
}

#pragma mark - setters

#pragma mark - getters
- (UIButton *)dataModeButton {
    if (!_dataModeButton) {
        _dataModeButton = [[UIButton alloc] init];
        _dataModeButton.accessibilityLabel = [PrismIdentifierUtil identifier];
        _dataModeButton.layer.cornerRadius = (PrismDataSwitchViewHeight - 6) / 2;
        _dataModeButton.layer.masksToBounds = YES;
        _dataModeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_dataModeButton setTitle:@"看数据" forState:UIControlStateNormal];
        [_dataModeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_dataModeButton setTitleColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0] forState:UIControlStateSelected];
        [_dataModeButton prism_setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_dataModeButton prism_setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_dataModeButton addTarget:self action:@selector(dataModeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dataModeButton;
}

- (UIButton *)heatModeButton {
    if (!_heatModeButton) {
        _heatModeButton = [[UIButton alloc] init];
        _heatModeButton.accessibilityLabel = [PrismIdentifierUtil identifier];
        _heatModeButton.layer.cornerRadius = (PrismDataSwitchViewHeight - 6) / 2;
        _heatModeButton.layer.masksToBounds = YES;
        _heatModeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_heatModeButton setTitle:@"看热力" forState:UIControlStateNormal];
        [_heatModeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_heatModeButton setTitleColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0] forState:UIControlStateSelected];
        [_heatModeButton prism_setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_heatModeButton prism_setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_heatModeButton addTarget:self action:@selector(heatModeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _heatModeButton;
}

@end
