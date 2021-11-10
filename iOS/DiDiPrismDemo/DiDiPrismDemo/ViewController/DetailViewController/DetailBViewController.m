//
//  DetailBViewController.m
//  DiDiPrismDemo
//
//  Created by hulk on 2020/10/26.
//  Copyright © 2020 prism. All rights reserved.
//

#import "DetailBViewController.h"
#import <Masonry/Masonry.h>
#import "MBProgressHUD.h"

@interface DetailBViewController ()
@property (nonatomic, strong) UILabel *buttonLabel;
@property (nonatomic, strong) UILabel *textfieldLabel;
@property (nonatomic, strong) UILabel *switchLabel;
@property (nonatomic, strong) UILabel *testTapLabel;
@property (nonatomic, strong) UIView *testTapView;
@property (nonatomic, strong) UILabel *testLongPressLabel;
@property (nonatomic, strong) UIView *testLongPressView;
@property (nonatomic, strong) UIButton *testButton;
@property (nonatomic, strong) UITextField *testTextField;
@property (nonatomic, strong) UISwitch *testSwitch;
@end

@implementation DetailBViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initView];
    
}

#pragma mark - action
- (void)tapAction:(UITapGestureRecognizer*)gesture {
    [self.testTextField resignFirstResponder];
}

- (void)testDownAction:(UIButton*)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = sender.titleLabel.text;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (void)testAction:(UIButton*)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = sender.titleLabel.text;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (void)testTapAction:(UITapGestureRecognizer*)gesture {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"点击手势触发";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (void)testLongPressAction:(UILongPressGestureRecognizer*)gesture {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"长按手势触发";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (void)testSwitchAction:(UISwitch*)sender {
}

- (void)testTextFieldAction:(UITextField*)sender {
}


#pragma mark - delegate

#pragma mark - public method

#pragma mark - private method
- (void)_initView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"详情页-B";
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tapGesture];
    
    [self.view addSubview:self.buttonLabel];
    [self.view addSubview:self.testButton];
    [self.view addSubview:self.textfieldLabel];
    [self.view addSubview:self.testTextField];
    [self.view addSubview:self.switchLabel];
    [self.view addSubview:self.testSwitch];
    [self.view addSubview:self.testTapLabel];
    [self.view addSubview:self.testTapView];
    [self.view addSubview:self.testLongPressLabel];
    [self.view addSubview:self.testLongPressView];
    
    [self.buttonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.view).offset(130);
    }];
    [self.testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.buttonLabel);
        make.left.equalTo(self.buttonLabel.mas_right).offset(30);
        make.width.mas_equalTo(100);
    }];
    [self.textfieldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.buttonLabel.mas_bottom).offset(50);
    }];
    [self.testTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textfieldLabel);
        make.left.equalTo(self.textfieldLabel.mas_right).offset(30);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(40);
    }];
    [self.switchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.textfieldLabel.mas_bottom).offset(50);
    }];
    [self.testSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.switchLabel);
        make.left.equalTo(self.switchLabel.mas_right).offset(30);
        make.width.mas_equalTo(100);
    }];
    [self.testTapLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.switchLabel.mas_bottom).offset(50);
    }];
    [self.testTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.testTapLabel);
        make.left.equalTo(self.testTapLabel.mas_right).offset(30);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    [self.testLongPressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.testTapLabel.mas_bottom).offset(50);
    }];
    [self.testLongPressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.testLongPressLabel);
        make.left.equalTo(self.testLongPressLabel.mas_right).offset(30);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - setters

#pragma mark - getters
- (UILabel *)buttonLabel {
    if (!_buttonLabel) {
        _buttonLabel = [[UILabel alloc] init];
        _buttonLabel.font = [UIFont systemFontOfSize:15];
        _buttonLabel.textColor = [UIColor blackColor];
        _buttonLabel.text = @"Button示例：";
    }
    return _buttonLabel;
}

- (UILabel *)textfieldLabel {
    if (!_textfieldLabel) {
        _textfieldLabel = [[UILabel alloc] init];
        _textfieldLabel.font = [UIFont systemFontOfSize:15];
        _textfieldLabel.textColor = [UIColor blackColor];
        _textfieldLabel.text = @"TextField示例：";
    }
    return _textfieldLabel;
}

- (UILabel *)switchLabel {
    if (!_switchLabel) {
        _switchLabel = [[UILabel alloc] init];
        _switchLabel.font = [UIFont systemFontOfSize:15];
        _switchLabel.textColor = [UIColor blackColor];
        _switchLabel.text = @"Switch示例：";
    }
    return _switchLabel;
}

- (UILabel *)testTapLabel {
    if (!_testTapLabel) {
        _testTapLabel = [[UILabel alloc] init];
        _testTapLabel.font = [UIFont systemFontOfSize:15];
        _testTapLabel.textColor = [UIColor blackColor];
        _testTapLabel.text = @"点击手势示例：";
    }
    return _testTapLabel;
}

- (UIView *)testTapView {
    if (!_testTapView) {
        _testTapView = [[UIView alloc] init];
        _testTapView.backgroundColor = [UIColor blueColor];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(testTapAction:)];
        [_testTapView addGestureRecognizer:tapGesture];
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor whiteColor];
        label.text = @"测试点击手势";
        [_testTapView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_testTapView);
        }];
    }
    return _testTapView;
}

- (UILabel *)testLongPressLabel {
    if (!_testLongPressLabel) {
        _testLongPressLabel = [[UILabel alloc] init];
        _testLongPressLabel.font = [UIFont systemFontOfSize:15];
        _testLongPressLabel.textColor = [UIColor blackColor];
        _testLongPressLabel.text = @"长按手势示例：";
    }
    return _testLongPressLabel;
}

- (UIView *)testLongPressView {
    if (!_testLongPressView) {
        _testLongPressView = [[UIView alloc] init];
        _testLongPressView.backgroundColor = [UIColor blueColor];
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(testLongPressAction:)];
        [_testLongPressView addGestureRecognizer:longPressGesture];
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor whiteColor];
        label.text = @"测试长按手势";
        [_testLongPressView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_testLongPressView);
        }];
    }
    return _testLongPressView;
}

- (UIButton *)testButton {
    if (!_testButton) {
        _testButton = [[UIButton alloc] init];
        _testButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_testButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_testButton setTitle:@"测试按钮" forState:UIControlStateNormal];
        _testButton.layer.borderColor = [UIColor grayColor].CGColor;
        _testButton.layer.borderWidth = 1.0;
        [_testButton addTarget:self action:@selector(testDownAction:) forControlEvents:UIControlEventTouchDown];
        [_testButton addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testButton;
}

- (UITextField *)testTextField {
    if (!_testTextField) {
        _testTextField = [[UITextField alloc] init];
        _testTextField.placeholder = @"点我输入..";
        _testTextField.borderStyle = UITextBorderStyleRoundedRect;
        [_testTextField addTarget:self action:@selector(testTextFieldAction:) forControlEvents:UIControlEventEditingDidBegin];
    }
    return _testTextField;
}

- (UISwitch *)testSwitch {
    if (!_testSwitch) {
        _testSwitch = [[UISwitch alloc] init];
        [_testSwitch addTarget:self action:@selector(testSwitchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _testSwitch;
}
@end
