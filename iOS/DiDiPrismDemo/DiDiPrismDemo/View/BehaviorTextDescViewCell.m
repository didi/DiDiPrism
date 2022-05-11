//
//  PrismBehaviorTextDescViewCell.m
//  DiDiPrismDemo
//
//  Created by hulk on 2019/11/7.
//

#import "BehaviorTextDescViewCell.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
#import <DiDiPrism/UIColor+PrismExtends.h>

#define kPhoneWidth 22
#define kPhoneHeight 42

@interface BehaviorTextDescViewCell()
@property (nonatomic, strong) UILabel *operationLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *phoneView;
@property (nonatomic, strong) UIView *phoneBarView;
@property (nonatomic, strong) UIView *locationView;
@property (nonatomic, strong) UILabel *locationLabel;

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
            make.left.equalTo(self.contentView).offset(125);
            make.right.equalTo(self.timeLabel.mas_left).offset(-15);
            make.top.equalTo(self.contentView).offset(20);
            make.bottom.equalTo(self.contentView).offset(-20);
            make.height.mas_equalTo(height);
        }];
    }
    else if (_textModel.descType == PrismBehaviorDescTypeNone) {
        [self.contentImageView removeConstraints:self.contentImageView.constraints];
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(125);
            make.right.equalTo(self.timeLabel.mas_left).offset(-15);
            make.top.equalTo(self.contentView).offset(20);
            make.bottom.equalTo(self.contentView).offset(-20);
            make.height.mas_equalTo(20);
        }];
    }
    else {
        [self.contentImageView removeConstraints:self.contentImageView.constraints];
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(125);
            make.right.equalTo(self.timeLabel.mas_left).offset(-15);
            make.top.equalTo(self.contentView).offset(20);
            make.bottom.equalTo(self.contentView).offset(-20);
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
    [self.contentView addSubview:self.phoneView];
    [self.contentView addSubview:self.phoneBarView];
    [self.contentView addSubview:self.locationView];
    [self.contentView addSubview:self.locationLabel];
    
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
    }];
    [self.operationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(37);
        make.centerY.equalTo(self.contentView);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
    }];
    [self.failFlagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(1);
    }];
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(95);
        make.top.equalTo(self.contentView).offset(7);
        make.width.mas_equalTo(kPhoneWidth);
        make.height.mas_equalTo(kPhoneHeight);
    }];
    [self.phoneBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneView);
        make.centerX.equalTo(self.phoneView);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(4);
    }];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.phoneView);
        make.top.equalTo(self.phoneView.mas_bottom).offset(2);
    }];
}

#pragma mark - setters
- (void)setTextModel:(PrismBehaviorTextModel *)textModel {
    _textModel = textModel;
    
    self.operationLabel.text = _textModel.operationName;
    self.timeLabel.text = _textModel.descTime;
    self.locationLabel.text = _textModel.areaText;
    switch (_textModel.descType) {
        case PrismBehaviorDescTypeNone:
            {
                self.contentLabel.text = @"[无法翻译]";
                self.contentLabel.hidden = NO;
                self.contentImageView.hidden = YES;
            }
            break;
        case PrismBehaviorDescTypeText:
            {
                NSString *moduleText = _textModel.moduleText.length ? [NSString stringWithFormat:@"%@ - ", _textModel.moduleText] : @"";
                NSString *elementName = _textModel.elementName.length ? [NSString stringWithFormat:@"（%@）", _textModel.elementName] : @"";
                self.contentLabel.text = [NSString stringWithFormat:@"%@%@%@", moduleText, _textModel.descContent, elementName];
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
        case PrismBehaviorDescTypeCode:
            {
                NSString *moduleText = _textModel.moduleText.length ? [NSString stringWithFormat:@"%@ - ", _textModel.moduleText] : @"";
                NSString *elementName = _textModel.elementName.length ? [NSString stringWithFormat:@"（%@）", _textModel.elementName] : @"";
                self.contentLabel.text = [NSString stringWithFormat:@"%@[函数名]%@%@", moduleText, _textModel.descContent, elementName];
                self.contentLabel.hidden = NO;
                self.contentImageView.hidden = YES;
            }
            break;
        default:
            break;
    }
    
    
    CGFloat width = 0;
    CGFloat height = 0;
    CGFloat left = 0;
    CGFloat top = 0;
    
    self.phoneView.hidden = NO;
    self.phoneView.text = nil;
    self.phoneBarView.hidden = NO;
    self.locationView.hidden = NO;
    self.locationLabel.hidden = NO;
    
    switch (_textModel.areaInfo) {
        case PrismInstructionAreaUp:
        {
            width = 6;
            height = kPhoneHeight / 2;
            left = kPhoneWidth / 2 - 3;
            top = 0;
        }
            break;
        case PrismInstructionAreaBottom:
        {
            width = 6;
            height = kPhoneHeight / 2;
            left = kPhoneWidth / 2 - 3;
            top = kPhoneHeight / 2;
        }
            break;
        case PrismInstructionAreaLeft:
        {
            width = kPhoneWidth / 2;
            height = 6;
            left = 0;
            top = kPhoneHeight / 2 - 3;
        }
            break;
        case PrismInstructionAreaRight:
        {
            width = kPhoneWidth / 2;
            height = 6;
            left = kPhoneWidth / 2;
            top = kPhoneHeight / 2 - 3;
        }
            break;
        case PrismInstructionAreaCenter:
        {
            width = 12;
            height = 18;
            left = kPhoneWidth / 2 - 6;
            top = kPhoneHeight / 2 - 9;
        }
            break;
        case PrismInstructionAreaUpLeft:
        {
            width = kPhoneWidth / 2;
            height = kPhoneHeight / 2;
            left = 0;
            top = 0;
        }
            break;
        case PrismInstructionAreaUpRight:
        {
            width = kPhoneWidth / 2;
            height = kPhoneHeight / 2;
            left = kPhoneWidth / 2;
            top = 0;
        }
            break;
        case PrismInstructionAreaBottomLeft:
        {
            width = kPhoneWidth / 2;
            height = kPhoneHeight / 2;
            left = 0;
            top = kPhoneHeight / 2;
        }
            break;
        case PrismInstructionAreaBottomRight:
        {
            width = kPhoneWidth / 2;
            height = kPhoneHeight / 2;
            left = kPhoneWidth / 2;
            top = kPhoneHeight / 2;
        }
            break;
        case PrismInstructionAreaCanScroll:
        {
            self.phoneView.text = @"---\r\n---\r\n---";
        }
            break;
        default:
        {
            self.phoneView.hidden = YES;
            self.phoneBarView.hidden = YES;
            self.locationView.hidden = YES;
            self.locationLabel.hidden = YES;
        }
            break;
    }
    
    [self.locationView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
        make.left.equalTo(self.phoneView).offset(left);
        make.top.equalTo(self.phoneView).offset(top);
    }];
    
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

#pragma mark - getters
- (UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont systemFontOfSize:12];
        _indexLabel.textColor = [UIColor prism_colorWithHexString:@"#666666"];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _indexLabel;
}

- (UILabel *)operationLabel {
    if (!_operationLabel) {
        _operationLabel = [[UILabel alloc] init];
        _operationLabel.font = [UIFont systemFontOfSize:12];
        _operationLabel.textColor = [UIColor prism_colorWithHexString:@"#666666"];
        _operationLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _operationLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont boldSystemFontOfSize:12];
        _contentLabel.textColor = [UIColor prism_colorWithHexString:@"#333333"];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
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
        _timeLabel.font = [UIFont boldSystemFontOfSize:12];
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

- (UILabel *)phoneView {
    if (!_phoneView) {
        _phoneView = [[UILabel alloc] init];
        _phoneView.backgroundColor = [UIColor clearColor];
        _phoneView.layer.borderWidth = 1.0;
        _phoneView.layer.borderColor = [UIColor prism_colorWithHexString:@"#666666"].CGColor;
        _phoneView.layer.cornerRadius = 3.0;
        _phoneView.textColor = [UIColor prism_colorWithHexString:@"#666666"];
        _phoneView.font = [UIFont systemFontOfSize:8];
        _phoneView.textAlignment = NSTextAlignmentCenter;
        _phoneView.numberOfLines = 0;
    }
    return _phoneView;
}

- (UIView *)phoneBarView {
    if (!_phoneBarView) {
        _phoneBarView = [[UIView alloc] init];
        _phoneBarView.backgroundColor = [UIColor prism_colorWithHexString:@"#666666"];
        _phoneBarView.layer.cornerRadius = 1.0;
    }
    return _phoneBarView;
}

- (UIView *)locationView {
    if (!_locationView) {
        _locationView = [[UIView alloc] init];
        _locationView.backgroundColor = [[UIColor prism_colorWithHexString:@"#666666"] colorWithAlphaComponent:0.6];
    }
    return _locationView;
}

- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.font = [UIFont systemFontOfSize:10];
        _locationLabel.textColor = [UIColor prism_colorWithHexString:@"#666666"];
        _locationLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _locationLabel;
}
@end
