//
//  PrismDataFloatingView.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import "PrismDataFloatingView.h"
#import <Masonry/Masonry.h>
#import <DiDiPrism/PrismIdentifierUtil.h>
// View
#import "PrismDataHeatMapView.h"
// Category
#import <DiDiPrism/UIColor+PrismExtends.h>

@interface PrismDataFloatingView()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *flagContentLabel;
@property (nonatomic, strong) PrismDataHeatMapView *heatMapView;
@end

@implementation PrismDataFloatingView
#pragma mark - life cycle
- (instancetype)init {
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self);
    }];
    [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(2, 5, 2, 5));
    }];
    [_flagContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.greaterThanOrEqualTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(14);
    }];
}

#pragma mark - action

#pragma mark - delegate

#pragma mark - public method

#pragma mark - private method
- (void)_initView {
    self.accessibilityIdentifier = [PrismIdentifierUtil identifier];
    self.userInteractionEnabled = NO;
    [self setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.4]];
    self.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor;
    self.layer.borderWidth = 0.5f;
    
    [self addSubview:self.flagContentLabel];
    [self addSubview:self.contentView];
    [self addSubview:self.contentLabel];
    [self addSubview:self.heatMapView];
    [self setNeedsUpdateConstraints];
}

- (CGRect)generateFrameWithSuperview:(UIView*)superview {
    if (!superview) {
        return CGRectZero;
    }
    CGRect frameOfElement = superview.frame;
    CGFloat widthOfFloatingView = frameOfElement.size.width;
    CGFloat heightOfFloatingView = frameOfElement.size.height;
    CGFloat xOffset = 0;
    CGFloat yOffset = 0;
    BOOL needResize = NO;
    if (widthOfFloatingView < MinWidthOfPrismDataFloatingView) {
        needResize = YES;
        if (widthOfFloatingView != 0) {
            xOffset = (MinWidthOfPrismDataFloatingView - widthOfFloatingView) / 2;
        }
        widthOfFloatingView = MinWidthOfPrismDataFloatingView;
    }
    if (heightOfFloatingView < MinHeightOfPrismDataFloatingView) {
        needResize = YES;
        if (heightOfFloatingView != 0) {
            yOffset =(MinHeightOfPrismDataFloatingView - heightOfFloatingView) / 2;
        }
        heightOfFloatingView = MinHeightOfPrismDataFloatingView;
    }
    
    CGRect frameOfLookView = CGRectZero;
    if (needResize && (superview.clipsToBounds || superview.layer.masksToBounds)) {
        frameOfLookView = CGRectMake(frameOfElement.origin.x + 1 - xOffset, frameOfElement.origin.y + 1 - yOffset, widthOfFloatingView - 2, heightOfFloatingView - 2);
    }
    else {
        frameOfLookView = CGRectMake(1 - xOffset, 1 - yOffset, widthOfFloatingView - 2, heightOfFloatingView - 2);
    }
    return frameOfLookView;
}

#pragma mark - setters
- (void)setFrame:(CGRect)frame {
    frame = [self generateFrameWithSuperview:self.superview];
    [super setFrame:frame];
}

- (void)setShowMode:(PrismDataFloatingViewMode)showMode {
    _showMode = showMode;
    
    switch (_showMode) {
        case PrismDataFloatingViewModeNormal:
        {
            self.contentLabel.textColor = [UIColor whiteColor];
            self.contentView.backgroundColor = [UIColor prism_colorWithHexString:@"#5BAEFF"];
            self.backgroundColor = [[UIColor prism_colorWithHexString:@"#5BAEFF"] colorWithAlphaComponent:0.2];
            self.layer.borderColor = [UIColor prism_colorWithHexString:@"#5BAEFF"].CGColor;
        }
            break;
        case PrismDataFloatingViewModeSelected:
        {
            self.contentLabel.textColor = [UIColor whiteColor];
            self.contentView.backgroundColor = [UIColor clearColor];
            self.backgroundColor = [UIColor colorWithRed:0.01 green:0.03 blue:0.08 alpha:0.8];
            self.layer.borderColor = [UIColor clearColor].CGColor;
        }
            break;
        case PrismDataFloatingViewModeNoText:
        {
            self.contentView.backgroundColor = [UIColor clearColor];
            self.backgroundColor = [UIColor clearColor];
            self.layer.borderColor = [UIColor clearColor].CGColor;
        }
            break;
        default:
            break;
    }
}

- (void)setModel:(PrismDataFloatingModel *)model {
    _model = model;
    
    self.contentLabel.text = [NSString stringWithFormat:@"%ld", _model.value];
    self.flagContentLabel.text = [NSString stringWithFormat:@" %@", _model.flagContent];
    self.heatMapView.value = _model.value;
    self.heatMapView.standardValue = _model.standardValue;
}

- (void)setHeatMapEnable:(BOOL)heatMapEnable {
    _heatMapEnable = heatMapEnable;
    self.heatMapView.hidden = !_heatMapEnable;
    if (_heatMapEnable) {
        self.heatMapView.frame = CGRectGetWidth(self.bounds) * CGRectGetHeight(self.bounds) > CGRectGetWidth(self.superview.bounds) * CGRectGetHeight(self.superview.bounds) ? self.bounds : self.superview.bounds;
    }
}

#pragma mark - getters
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.userInteractionEnabled = NO;
    }
    return _contentView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.accessibilityIdentifier = [PrismIdentifierUtil identifier];
        _contentLabel.userInteractionEnabled = NO;
        _contentLabel.font = [UIFont systemFontOfSize:9];
        _contentLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _contentLabel;
}

- (UILabel *)flagContentLabel {
    if (!_flagContentLabel) {
        _flagContentLabel = [[UILabel alloc] init];
        _flagContentLabel.accessibilityIdentifier = [PrismIdentifierUtil identifier];
        _flagContentLabel.userInteractionEnabled = NO;
        _flagContentLabel.font = [UIFont systemFontOfSize:11];
        _flagContentLabel.textColor = [UIColor whiteColor];
        _flagContentLabel.backgroundColor = [UIColor redColor];
        _flagContentLabel.numberOfLines = 1;
        _flagContentLabel.textAlignment = NSTextAlignmentRight;
    }
    return _flagContentLabel;
}

- (PrismDataHeatMapView *)heatMapView {
    if (!_heatMapView) {
        _heatMapView = [[PrismDataHeatMapView alloc] init];
    }
    return _heatMapView;
}
@end
