//
//  PrismBehaviorTextDescNodeCell.m
//  DiDiPrismDemo
//
//  Created by hulk on 2020/2/12.
//

#import "BehaviorTextDescNodeCell.h"
#import <Masonry/Masonry.h>
#import <DiDiPrism/UIColor+PrismExtends.h>

@interface BehaviorTextDescNodeCell()

@end

@implementation BehaviorTextDescNodeCell
#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - action

#pragma mark - delegate

#pragma mark - public method

#pragma mark - private method
- (void)initView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(14);
        make.top.equalTo(self.contentView).offset(20);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
}

#pragma mark - setters

#pragma mark - getters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = [UIColor prism_colorWithHexString:@"#333333"];
    }
    return _titleLabel;
}

@end
