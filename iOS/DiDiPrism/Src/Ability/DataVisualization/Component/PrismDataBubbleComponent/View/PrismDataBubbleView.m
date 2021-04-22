//
//  PrismDataBubbleView.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/23.
//

#import "PrismDataBubbleView.h"
#import "Masonry.h"
#import "PrismIdentifierUtil.h"

@interface PrismDataBubbleView()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *backgroundView;
@end

@implementation PrismDataBubbleView
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
- (void)longPressAction:(UILongPressGestureRecognizer*)gesture {
    
}

- (void)tapAction:(UITapGestureRecognizer*)gesture {
    
}

#pragma mark - delegate
#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

#pragma mark - public method

#pragma mark - override method

#pragma mark - private method
- (void)initView {
    self.backgroundColor = [UIColor clearColor];
    
    // 为了覆盖全局的长按手势
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPressGesture.accessibilityLabel = [PrismIdentifierUtil identifier];
    longPressGesture.delegate = self;
    longPressGesture.cancelsTouchesInView = NO;
    [self addGestureRecognizer:longPressGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapGesture.accessibilityLabel = [PrismIdentifierUtil identifier];
    [self addGestureRecognizer:tapGesture];
    
    [self addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.timeLabel];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.backgroundView);
        make.width.mas_equalTo(PrismDataBubbleViewFoldWidth);
    }];
}

#pragma mark - setters
- (void)setModel:(PrismDataBubbleModel *)model {
    _model = model;
    
    self.timeLabel.text = _model.content;
}

#pragma mark - getters
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont boldSystemFontOfSize:12];
        _timeLabel.textColor = [UIColor colorWithRed:0.36 green:0.68 blue:1 alpha:1];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor colorWithRed:0.01 green:0.03 blue:0.08 alpha:0.8];
        _backgroundView.layer.cornerRadius = 19.0f;
        _backgroundView.layer.masksToBounds = YES;
    }
    return _backgroundView;
}
@end
