//
//  EntranceViewController.m
//  DiDiPrismDemo
//
//  Created by hulk on 2020/10/26.
//  Copyright © 2020 prism. All rights reserved.
//

#import "EntranceViewController.h"
#import "BehaviorReplayViewController.h"
#import "BehaviorDetectViewController.h"
#import "DataVisualizationViewController.h"

@interface EntranceViewController ()

@end

@implementation EntranceViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initView];
    
}

#pragma mark - action
- (void)goReplayAction:(UIButton*)sender {
    BehaviorReplayViewController *replayVC = [[BehaviorReplayViewController alloc] init];
    [self.navigationController pushViewController:replayVC animated:YES];
}

- (void)goDetectAction:(UIButton*)sender {
    BehaviorDetectViewController *detectVC = [[BehaviorDetectViewController alloc] init];
    [self.navigationController pushViewController:detectVC animated:YES];
}

- (void)goVisualizationAction:(UIButton*)sender {
    DataVisualizationViewController *visualizationtVC = [[DataVisualizationViewController alloc] init];
    [self.navigationController pushViewController:visualizationtVC animated:YES];
}

#pragma mark - delegate

#pragma mark - public method

#pragma mark - private method
- (void)_initView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"小桔棱镜演示";
    
    UIButton *goReplayButton = [self generateButton];
    goReplayButton.frame = CGRectMake(110, 200, 180, 90);
    [goReplayButton setTitle:@"行为回放" forState:UIControlStateNormal];
    [goReplayButton addTarget:self action:@selector(goReplayAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goReplayButton];
    
    UIButton *goDetectButton = [self generateButton];
    goDetectButton.frame = CGRectMake(110, 330, 180, 90);
    [goDetectButton setTitle:@"行为检测" forState:UIControlStateNormal];
    [goDetectButton addTarget:self action:@selector(goDetectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goDetectButton];
    
    UIButton *goVisualizationButton = [self generateButton];
    goVisualizationButton.frame = CGRectMake(110, 460, 180, 90);
    [goVisualizationButton setTitle:@"数据可视化" forState:UIControlStateNormal];
    [goVisualizationButton addTarget:self action:@selector(goVisualizationAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goVisualizationButton];
}

- (UIButton*)generateButton {
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.borderColor = [UIColor grayColor].CGColor;
    button.layer.borderWidth = 1.0;
    return button;
}

#pragma mark - setters

#pragma mark - getters

@end
