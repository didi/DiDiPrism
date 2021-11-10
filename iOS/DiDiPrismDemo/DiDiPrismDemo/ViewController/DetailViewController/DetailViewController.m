//
//  DetailViewController.m
//  DiDiPrismDemo
//
//  Created by hulk on 2020/10/26.
//  Copyright © 2020 prism. All rights reserved.
//

#import "DetailViewController.h"
#import "PrismAdapter.h"
#import "DetailTableViewCell.h"
#import <Masonry/Masonry.h>
#import "DetailAViewController.h"
#import "DetailBViewController.h"
#import "DetailPresentedViewController.h"
#import "WebViewController.h"

@interface DetailViewController () <UITableViewDelegate,UITableViewDataSource, DetailTableViewCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation DetailViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initView];
    
}

#pragma mark - action

#pragma mark - delegate
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailAViewController *viewController = [[DetailAViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailTableViewCell"];
    if (!cell) {
        cell = [[DetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailTableViewCell"];
        cell.delegate = self;
    }
    cell.index = indexPath.row;
    Prism_RemoveAllEventIds(cell);
    Prism_AddExposureEventId(cell, @"event_id_1");
    return cell;
}

#pragma mark - DetailTableViewCellDelegate
- (void)didGoButtonSelectedWithIndex:(NSInteger)index {
    UIViewController *viewController = nil;
    index = index % 4;
    if (index == 0) {
        viewController = [[DetailBViewController alloc] init];
    }
    else if (index == 1) {
        viewController = [[WebViewController alloc] init];
    }
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    if (index == 2) {
        [self.navigationController presentViewController:[[DetailPresentedViewController alloc] init] animated:YES completion:nil];
    }
}

#pragma mark - public method

#pragma mark - private method
- (void)_initView {
    self.view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    self.title = @"详情首页";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - setters

#pragma mark - getters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
@end
