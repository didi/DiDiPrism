//
//  PrismDataFilterView.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/23.
//

#import "PrismDataFilterView.h"
#import "Masonry.h"
#import "PrismIdentifierUtil.h"

@interface PrismDataFilterView()
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *middleButton;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, assign) BOOL isFolding;
@end

@implementation PrismDataFilterView
#pragma mark - life cycle
- (instancetype)init {
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self initData];
    }
    return self;
}

#pragma mark - action
- (void)foldAction:(UIButton*)sender {
    if (self.middleButton.isSelected) {
        self.middleButton.selected = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchMiddleButton:isShow:)]) {
            [self.delegate didTouchMiddleButton:self.middleButton isShow:NO];
        }
        return;
    }
    self.isFolding = !self.isFolding;
    CGRect lastFrame = self.frame;
    CGFloat currentWidth = self.isFolding ? PrismDataFilterViewFoldWidth : PrismDataFilterViewUnfoldWidth;
    CGFloat currentOrignX = self.isFolding ? PrismDataFilterViewOrignX : ([UIScreen mainScreen].applicationFrame.size.width - currentWidth) / 2;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(currentOrignX, lastFrame.origin.y, currentWidth, lastFrame.size.height);
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchLeftButton:isFolding:)]) {
        [self.delegate didTouchLeftButton:sender isFolding:self.isFolding];
    }
}

- (void)editAction:(UIButton*)sender {
    sender.selected = !sender.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchMiddleButton:isShow:)]) {
        [self.delegate didTouchMiddleButton:sender isShow:sender.isSelected];
    }
}

- (void)selectPageAction:(UIButton*)sender {
    if (self.middleButton.isSelected) {
        self.middleButton.selected = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchMiddleButton:isShow:)]) {
            [self.delegate didTouchMiddleButton:self.middleButton isShow:NO];
        }
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchRightButton:)]) {
        [self.delegate didTouchRightButton:sender];
    }
}

#pragma mark - delegate

#pragma mark - public method

#pragma mark - private method
- (void)initView {
    self.accessibilityIdentifier = [PrismIdentifierUtil identifier];
    self.backgroundColor = [UIColor colorWithRed:0.01 green:0.03 blue:0.08 alpha:0.8];
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.cornerRadius = PrismDataFilterViewHeight / 2;
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.leftButton];
    [self addSubview:self.middleButton];
    [self addSubview:self.rightButton];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(PrismDataFilterViewFoldWidth);
    }];
    [self.middleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.leftButton.mas_right);
        make.width.mas_equalTo(PrismDataFilterViewUnfoldWidth - PrismDataFilterViewFoldWidth - PrismDataFilterViewSelectPageWidth);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.middleButton.mas_right);
        make.width.mas_equalTo(PrismDataFilterViewSelectPageWidth);
    }];
}

- (void)initData {
    
}

#pragma mark - setters

#pragma mark - getters
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        _leftButton.accessibilityLabel = [PrismIdentifierUtil identifier];
//        [_foldButton setImage:[EDImageUtil imageNamed:@"easydot_filter_normal.png"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(foldAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)middleButton {
    if (!_middleButton) {
        _middleButton = [[UIButton alloc] init];
        _middleButton.accessibilityLabel = [PrismIdentifierUtil identifier];
        [_middleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_middleButton setTitleColor:[UIColor colorWithRed:0.36 green:0.68 blue:1.0 alpha:1.0] forState:UIControlStateSelected];
        _middleButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _middleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_middleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        [_middleButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _middleButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        _rightButton.accessibilityLabel = [PrismIdentifierUtil identifier];
        _rightButton.backgroundColor = [UIColor colorWithRed:0.18 green:0.21 blue:0.26 alpha:1.0];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightButton setTitle:@" 任意门" forState:UIControlStateNormal];
//        [_selectPageButton setImage:[EDImageUtil imageNamed:@"easydot_data_goto_page.png"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(selectPageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
@end
