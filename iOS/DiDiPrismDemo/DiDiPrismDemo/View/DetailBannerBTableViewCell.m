//
//  DetailBannerBTableViewCell.m
//  DiDiPrismDemo
//
//  Created by hulk on 2020/10/26.
//  Copyright © 2020 prism. All rights reserved.
//

#import "DetailBannerBTableViewCell.h"
#import "Masonry.h"
#import "MBProgressHUD.h"

@interface DetailBannerBTableViewCell()
@property (nonatomic, strong) UIButton *firstButton;
@property (nonatomic, strong) UIButton *secondButton;
@property (nonatomic, strong) UIButton *thirdButton;
@property (nonatomic, strong) UIButton *fourthButton;

@end

@interface DetailBannerBTableViewCell()

@end

@implementation DetailBannerBTableViewCell
#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - action
- (void)tapAction:(UIButton*)sender {
    UIWindow *mainWindow = UIApplication.sharedApplication.delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = sender.titleLabel.text;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:mainWindow animated:YES];
    });
}

#pragma mark - delegate

#pragma mark - public method

#pragma mark - private method
- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.firstButton];
    [self.contentView addSubview:self.secondButton];
    [self.contentView addSubview:self.thirdButton];
    [self.contentView addSubview:self.fourthButton];
    
    UIWindow *mainWindow = UIApplication.sharedApplication.delegate.window;
    [self.firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(mainWindow.frame.size.width / 4);
        make.height.mas_equalTo(70);
    }];
    [self.secondButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.firstButton.mas_right);
        make.width.mas_equalTo(mainWindow.frame.size.width / 4);
        make.height.mas_equalTo(70);
    }];
    [self.thirdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.secondButton.mas_right);
        make.width.mas_equalTo(mainWindow.frame.size.width / 4);
        make.height.mas_equalTo(70);
    }];
    [self.fourthButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.thirdButton.mas_right);
        make.width.mas_equalTo(mainWindow.frame.size.width / 4);
        make.height.mas_equalTo(70);
    }];
}

#pragma mark - setters

#pragma mark - getters
- (UIButton *)firstButton {
    if (!_firstButton) {
        _firstButton = [[UIButton alloc] init];
        _firstButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_firstButton setTitle:@"展示位 1" forState:UIControlStateNormal];
        _firstButton.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.8];
        [_firstButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_firstButton addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _firstButton;
}

- (UIButton *)secondButton {
    if (!_secondButton) {
        _secondButton = [[UIButton alloc] init];
        _secondButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_secondButton setTitle:@"展示位 2" forState:UIControlStateNormal];
        _secondButton.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.4];
        [_secondButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_secondButton addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _secondButton;
}

- (UIButton *)thirdButton {
    if (!_thirdButton) {
        _thirdButton = [[UIButton alloc] init];
        _thirdButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_thirdButton setTitle:@"展示位 3" forState:UIControlStateNormal];
        _thirdButton.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.6];
        [_thirdButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_thirdButton addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _thirdButton;
}

- (UIButton *)fourthButton {
    if (!_fourthButton) {
        _fourthButton = [[UIButton alloc] init];
        _fourthButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_fourthButton setTitle:@"展示位 4" forState:UIControlStateNormal];
        _fourthButton.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        [_fourthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_fourthButton addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fourthButton;
}


@end
