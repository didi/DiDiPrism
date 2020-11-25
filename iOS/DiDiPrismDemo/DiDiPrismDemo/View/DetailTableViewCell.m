//
//  DetailTableViewCell.m
//  DiDiPrismDemo
//
//  Created by hulk on 2020/10/26.
//  Copyright © 2020 prism. All rights reserved.
//

#import "DetailTableViewCell.h"
#import "UIResponder+PrismIntercept.h"
#import "Masonry.h"

@interface DetailTableViewCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *goButton;

@end

@implementation DetailTableViewCell
#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - action
- (void)goAction:(UIButton*)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didGoButtonSelectedWithIndex:)]) {
        [self.delegate didGoButtonSelectedWithIndex:_index];
    }
}

#pragma mark - delegate

#pragma mark - public method

#pragma mark - private method
- (void)initView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.goButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(30);
    }];
    [self.goButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
}

#pragma mark - setters
- (void)setIndex:(NSInteger)index {
    _index = index;
    self.autoDotItemName = [NSString stringWithFormat:@"%ld", _index];
    self.titleLabel.text = [NSString stringWithFormat:@"Cell %ld\n点击前往详情页-A", _index];
    [self.goButton setTitle:[self buttonTitleOfIndex:_index % 2] forState:UIControlStateNormal];
}

#pragma mark - getters
- (NSString*)buttonTitleOfIndex:(NSInteger)index {
    if (index == 0) {
        return @"前往详情页-B";
    }
    return @"无跳转";
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIButton *)goButton {
    if (!_goButton) {
        _goButton = [[UIButton alloc] init];
        _goButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_goButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _goButton.layer.borderColor = [UIColor grayColor].CGColor;
        _goButton.layer.borderWidth = 1.0;
        [_goButton addTarget:self action:@selector(goAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goButton;
}


@end
