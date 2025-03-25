//
//  BehaviorDetectViewController.m
//  DiDiPrismDemo
//
//  Created by hulk on 2020/10/26.
//  Copyright © 2020 prism. All rights reserved.
//

#import "BehaviorDetectViewController.h"
#import "MBProgressHUD.h"
// Category
#import <DiDiPrism/NSDictionary+PrismExtends.h>
// ViewController
#import "DetailViewController.h"
// Manager
#import "PrismBehaviorDetectManager.h"
#import "PrismBehaviorRecordManager.h"

@interface BehaviorDetectViewController ()
@property (nonatomic, strong) UIButton *operationButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *seperatorLine;
@end

@implementation BehaviorDetectViewController
#pragma mark - life cycle
- (void)dealloc {
    [[PrismBehaviorRecordManager sharedManager] uninstall];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[PrismBehaviorRecordManager sharedManager] install];
    
    [self _addNotification];
    [self _initView];
    
}

#pragma mark - action
- (void)newInstructionNotification:(NSNotification*)notification {
    NSString *instruction = [notification.userInfo prism_stringForKey:@"instruction"];
    NSDictionary *params = [notification.userInfo prism_dictionaryForKey:@"params"];
    [[PrismBehaviorDetectManager sharedInstance] addInstruction:instruction withParams:params];
}

- (void)newRuleHitAction:(NSNotification*)notification {
    UIWindow *mainWindow = UIApplication.sharedApplication.delegate.window;
    NSString *ruleId = [notification.userInfo prism_stringForKey:@"ruleId"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = [NSString stringWithFormat:@"策略满足，策略ID为：%@", ruleId];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:mainWindow animated:YES];
    });
}

- (void)operateAction:(UIButton*)sender {
    [self _loadConfig];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"已进入检测模式";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

#pragma mark - delegate

#pragma mark - public method

#pragma mark - private method
- (void)_loadConfig {
    NSString *configFilePath = [[NSBundle mainBundle] pathForResource:@"prism_detect_config" ofType:@"json"];
    NSString *configString = [NSString stringWithContentsOfFile:configFilePath encoding:NSUTF8StringEncoding error:nil];
    PrismBehaviorDetectRuleConfigModel *configModel = [[PrismBehaviorDetectRuleConfigModel alloc] initWithString:configString error:nil];
    [[PrismBehaviorDetectManager sharedInstance] setupWithConfigModel:configModel];
}

- (void)_addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newInstructionNotification:) name:@"prism_new_instruction_notification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newRuleHitAction:) name:@"prism_behavior_detect_rule_hit" object:nil];
}

- (void)_initView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"行为检测演示";
    [self.view addSubview:self.operationButton];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.seperatorLine];
    
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    detailViewController.view.frame = CGRectMake(0, 170, self.view.frame.size.width, self.view.frame.size.height - 170);
    [self addChildViewController:detailViewController];
    [self.view addSubview:detailViewController.view];
}

- (UIButton*)generateButton {
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor grayColor];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return button;
}

#pragma mark - setters

#pragma mark - getters
- (UIButton *)operationButton {
    if (!_operationButton) {
        _operationButton = [self generateButton];
        _operationButton.frame = CGRectMake(20, 110, 100, 40);
        [_operationButton setTitle:@"加载配置" forState:UIControlStateNormal];
        [_operationButton addTarget:self action:@selector(operateAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _operationButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 105, 250, 50)];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = @"<--请先点击左侧的初始化按钮。\nDemo默认策略说明见：prism_detect_config_explanation.md文档。";
    }
    return _titleLabel;
}

- (UIView *)seperatorLine {
    if (!_seperatorLine) {
        _seperatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 169, self.view.frame.size.width, 0.5)];
        _seperatorLine.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    }
    return _seperatorLine;
}
@end
