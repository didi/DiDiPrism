//
//  PrismBehaviorReplayOperationView.m
//  DiDiPrismDemo
//
//  Created by hulk on 2019/10/9.
//

#import "BehaviorReplayOperationView.h"
#import "Masonry.h"

@interface BehaviorReplayOperationView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *stopButton;

@end

@implementation BehaviorReplayOperationView
#pragma mark - life cycle
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self addNotifications];
    }
    return self;
}

#pragma mark - action
- (void)stopAction:(UIButton*)sender {
    [self removeFromSuperview];
    [self.playButton setSelected:NO];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didStopButtonSelected)]) {
        [self.delegate didStopButtonSelected];
    }
}
- (void)playAction:(UIButton*)sender {
    [sender setSelected:!sender.isSelected];
    self.titleLabel.text = sender.isSelected ? @"已暂停" : @"回放中..";
    
    if (sender.isSelected) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPauseButtonSelected)]) {
            [self.delegate didPauseButtonSelected];
        }
    }
    else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didGoonButtonSelected)]) {
            [self.delegate didGoonButtonSelected];
        }
    }
}

- (void)stateChanged:(NSNotification*)notification {
    NSString *state = [notification.userInfo valueForKey:@"state"];
    self.titleLabel.text = state;
}

- (void)timeChanged:(NSNotification*)notification {
    NSString *time = [notification.userInfo valueForKey:@"time"];
    self.timeLabel.text = [NSString stringWithFormat:@"停留：%@", time];
}

#pragma mark - delegate

#pragma mark - public method

#pragma mark - private method
- (void)initView {
    self.backgroundColor = [UIColor colorWithRed:0.05 green:0.07 blue:0.11 alpha:0.9];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.playButton];
    [self addSubview:self.stopButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
    }];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.stopButton.mas_left).offset(-10);
    }];
    [self.stopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.width.mas_equalTo(60);
    }];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateChanged:) name:@"prism_behaviorreplay_statechanged_notification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeChanged:) name:@"prism_behaviorreplay_timechanged_notification" object:nil];
}

#pragma mark - setters

#pragma mark - getters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        _titleLabel.text = @"回放中..";
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    }
    return _timeLabel;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [[UIButton alloc] init];
        [_playButton setImage:[UIImage imageNamed:@"replay_stop@3x"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"replay_goon_play"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UIButton *)stopButton {
    if (!_stopButton) {
        _stopButton = [[UIButton alloc] init];
        _stopButton.backgroundColor = [UIColor clearColor];
        _stopButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_stopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_stopButton setTitle:@"关闭" forState:UIControlStateNormal];
        _stopButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_stopButton addTarget:self action:@selector(stopAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopButton;
}
@end
