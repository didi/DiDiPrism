//
//  PrismBehaviorTextDescViewCell.m
//  DiDiPrismDemo
//
//  Created by hulk on 2019/11/7.
//

#import "BehaviorTextDescViewCell.h"
#import "Masonry.h"
#import <SDWebImage/SDWebImage.h>
#import "UIColor+PrismExtends.h"

@interface BehaviorTextDescViewCell()
@property (nonatomic, strong) UILabel *operationLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation BehaviorTextDescViewCell
#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (_textModel.descType == PrismBehaviorDescTypeNetworkImage || _textModel.descType == PrismBehaviorDescTypeLocalImage) {
        CGFloat height = _textModel.descType == PrismBehaviorDescTypeNetworkImage ? 100 : 30;
        [self.contentLabel removeConstraints:self.contentLabel.constraints];
        [self.contentImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.operationLabel.mas_right).offset(50);
            make.right.equalTo(self.timeLabel.mas_left).offset(-20);
            make.top.equalTo(self.contentView).offset(13);
            make.bottom.equalTo(self.contentView).offset(-13);
            make.height.mas_equalTo(height);
        }];
    }
    else if (_textModel.descType == PrismBehaviorDescTypeNone) {
        [self.contentImageView removeConstraints:self.contentImageView.constraints];
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.operationLabel.mas_right).offset(50);
            make.right.equalTo(self.timeLabel.mas_left).offset(-20);
            make.top.equalTo(self.contentView).offset(13);
            make.bottom.equalTo(self.contentView).offset(-13);
            make.height.mas_equalTo(20);
        }];
    }
    else {
        [self.contentImageView removeConstraints:self.contentImageView.constraints];
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.operationLabel.mas_right).offset(50);
            make.right.equalTo(self.timeLabel.mas_left).offset(-20);
            make.top.equalTo(self.contentView).offset(13);
            make.bottom.equalTo(self.contentView).offset(-13);
            make.height.mas_equalTo(30);
        }];
    }
}

#pragma mark - action

#pragma mark - delegate

#pragma mark - public method

#pragma mark - private method
- (void)initView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.indexLabel];
    [self.contentView addSubview:self.operationLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.contentImageView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.failFlagLabel];
    
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(18);
        make.centerY.equalTo(self.contentView);
    }];
    [self.operationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.indexLabel).offset(55);
        make.centerY.equalTo(self.contentView);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.equalTo(self.contentView);
    }];
    [self.failFlagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(1);
    }];
}

#pragma mark - setters
- (void)setTextModel:(PrismBehaviorTextModel *)textModel {
    _textModel = textModel;
    
    self.operationLabel.text = _textModel.operationName;
    self.timeLabel.text = _textModel.descTime;
    switch (_textModel.descType) {
        case PrismBehaviorDescTypeNone:
            {
                self.operationLabel.text = nil;
                self.contentLabel.text = @"..";
                self.contentLabel.hidden = NO;
                self.contentImageView.hidden = YES;
            }
            break;
        case PrismBehaviorDescTypeText:
            {
                self.contentLabel.text = _textModel.descContent;
                self.contentLabel.hidden = NO;
                self.contentImageView.hidden = YES;
            }
            break;
        case PrismBehaviorDescTypeNetworkImage:
            {
                [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:_textModel.descContent]];
                self.contentImageView.hidden = NO;
                self.contentLabel.hidden = YES;
            }
            break;
        case PrismBehaviorDescTypeLocalImage:
            {
                NSString *descContent = _textModel.descContent;
                UIImage *image = [UIImage imageNamed:descContent];
                if (!image) {
                    NSArray<NSString*> *result = [descContent componentsSeparatedByString:@"/"];
                    if (result.lastObject) {
                        descContent = result.lastObject;
                    }
                    image = [UIImage imageNamed:descContent];
                    if (!image) {
                        for (NSBundle *bundle in [NSBundle allBundles]) {
                            image = [UIImage imageNamed:descContent inBundle:bundle compatibleWithTraitCollection:nil];
                            if (image) {
                                break;
                            }
                        }
                    }
                }
                
                [self.contentImageView setImage:image];
                self.contentImageView.hidden = NO;
                self.contentLabel.hidden = YES;
            }
            break;
        default:
            break;
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

#pragma mark - getters
- (UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont systemFontOfSize:14];
        _indexLabel.textColor = [UIColor prism_colorWithHexString:@"#666666"];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _indexLabel;
}

- (UILabel *)operationLabel {
    if (!_operationLabel) {
        _operationLabel = [[UILabel alloc] init];
        _operationLabel.font = [UIFont systemFontOfSize:14];
        _operationLabel.textColor = [UIColor prism_colorWithHexString:@"#666666"];
        _operationLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _operationLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont boldSystemFontOfSize:14];
        _contentLabel.textColor = [UIColor prism_colorWithHexString:@"#333333"];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLabel;
}

- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _contentImageView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont boldSystemFontOfSize:14];
        _timeLabel.textColor = [UIColor prism_colorWithHexString:@"#333333"];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (UILabel *)failFlagLabel {
    if (!_failFlagLabel) {
        _failFlagLabel = [[UILabel alloc] init];
        _failFlagLabel.font = [UIFont systemFontOfSize:10];
        _failFlagLabel.textColor = [UIColor redColor];
        _failFlagLabel.text = @" 视频回放失败起点";
        _failFlagLabel.hidden = YES;
    }
    return _failFlagLabel;
}
@end
