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
    // 悬浮窗组件
    [[PrismDataVisualizationManager sharedManager] registerComponent:[[PrismDataFloatingComponent alloc] init]];
    // 长按菜单组件
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
    // 模式切换组件
    [[PrismDataVisualizationManager sharedManager] registerComponent:[[PrismDataSwitchComponent alloc] init]];
    // 筛选器组件
    PrismDataFilterComponent *filterComponent = [[PrismDataFilterComponent alloc] init];
    NSMutableArray<PrismDataFilterItemConfig*> *filterItemConfig = [NSMutableArray array];
    PrismDataFilterItemConfig *itemConfig0 = [[PrismDataFilterItemConfig alloc] init];
    itemConfig0.index = 0;
    itemConfig0.title = @"城市";
    itemConfig0.items = @[];
    itemConfig0.style = PrismDataFilterEditorViewStylePicker;
    [filterItemConfig addObject:itemConfig0];
    PrismDataFilterItemConfig *itemConfig1 = [[PrismDataFilterItemConfig alloc] init];
    itemConfig1.index = 1;
    itemConfig1.title = @"用户类型";
    PrismDataFilterItem *item0 = [[PrismDataFilterItem alloc] init];
    item0.index = 0;
    item0.itemName = @"新用户";
    PrismDataFilterItem *item1 = [[PrismDataFilterItem alloc] init];
    item1.index = 1;
    item1.itemName = @"老用户";
    item1.isSelected = YES;
    itemConfig1.items = @[item0, item1];
    itemConfig1.style = PrismDataFilterEditorViewStyleRadio;
    [filterItemConfig addObject:itemConfig1];
    filterComponent.config = [filterItemConfig copy];
    [[PrismDataVisualizationManager sharedManager] registerComponent:filterComponent];
    // 气泡组件
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
