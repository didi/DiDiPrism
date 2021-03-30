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
    PrismDataFloatingMenuComponent *floatingMenuComponent = [[PrismDataFloatingMenuComponent alloc] init];
    PrismDataFloatingMenuItemConfig *clickItem = [[PrismDataFloatingMenuItemConfig alloc] init];
    clickItem.index = 1;
    clickItem.name = @"点击详情";
    clickItem.block = ^{
        
    };
    PrismDataFloatingMenuItemConfig *exposeItem = [[PrismDataFloatingMenuItemConfig alloc] init];
    exposeItem.index = 2;
    exposeItem.name = @"曝光详情";
    exposeItem.block = ^{
        
    };
    PrismDataFloatingMenuItemConfig *funnelItem = [[PrismDataFloatingMenuItemConfig alloc] init];
    funnelItem.index = 3;
    funnelItem.name = @"转化漏斗";
    funnelItem.block = ^{
        
    };
    [floatingMenuComponent setupWithConfig:@[clickItem,exposeItem,funnelItem]];
    [[PrismDataVisualizationManager sharedManager] registerComponent:floatingMenuComponent];
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
