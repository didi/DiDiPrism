//
//  DataVisualizationViewController.m
//  DiDiPrismDemo
//
//  Created by hulk on 2021/3/29.
//  Copyright © 2021 prism. All rights reserved.
//

#import "DataVisualizationViewController.h"
// ViewController
#import "DetailViewController.h"
// Manager
#import "PrismDataVisualizationManager.h"
// Component
#import "PrismDataFloatingComponent.h"
#import "PrismDataSwitchComponent.h"
#import "PrismDataFilterComponent.h"
#import "PrismDataBubbleComponent.h"
#import "PrismDataFloatingMenuComponent.h"

@interface DataVisualizationViewController ()

@end

@implementation DataVisualizationViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[PrismDataVisualizationManager sharedManager] setup];
    [[PrismDataVisualizationManager sharedManager] registerComponent:[[PrismDataFloatingComponent alloc] init]];
    [[PrismDataVisualizationManager sharedManager] registerComponent:[[PrismDataFloatingMenuComponent alloc] init]];
    [[PrismDataVisualizationManager sharedManager] registerComponent:[[PrismDataSwitchComponent alloc] init]];
    [[PrismDataVisualizationManager sharedManager] registerComponent:[[PrismDataFilterComponent alloc] init]];
    [[PrismDataVisualizationManager sharedManager] registerComponent:[[PrismDataBubbleComponent alloc] init]];
    [PrismDataVisualizationManager sharedManager].enable = YES;
    
    [self initView];
    [self initData];
    
}

#pragma mark - action

#pragma mark - delegate

#pragma mark - public method

#pragma mark - private method
- (void)initView {
    
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    detailViewController.view.frame = self.view.bounds;
    [self addChildViewController:detailViewController];
    [self.view addSubview:detailViewController.view];
}

- (void)initData {
    
}

#pragma mark - setters

#pragma mark - getters

@end
