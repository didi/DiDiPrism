//
//  DetailViewController.m
//  DiDiPrismDemo
//
//  Created by hulk on 2020/9/28.
//  Copyright © 2020 prism. All rights reserved.
//

#import "DetailAViewController.h"
#import "Masonry.h"
#import "MBProgressHUD.h"
#import "DetailAViewController.h"
#import "DetailTableViewCell.h"
#import "DetailBannerATableViewCell.h"
#import "DetailBannerBTableViewCell.h"

@interface DetailAViewController () <UITableViewDelegate,UITableViewDataSource,DetailTableViewCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation DetailAViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initView];
    
}

#pragma mark - action
- (void)tapAction:(UIButton*)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = sender.titleLabel.text;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

#pragma mark - delegate
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        DetailAViewController *viewController = [[DetailAViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 50;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        view.backgroundColor = [UIColor whiteColor];
        UIButton *firstButton = [self generateButton];
        firstButton.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
        [firstButton setTitle:@"分类 1" forState:UIControlStateNormal];
        UIButton *secondButton = [self generateButton];
        secondButton.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
        [secondButton setTitle:@"分类 2" forState:UIControlStateNormal];
        [view addSubview:firstButton];
        [view addSubview:secondButton];
        [firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(view);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(50);
        }];
        [secondButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(view);
            make.left.equalTo(firstButton.mas_right);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(50);
        }];
        return view;
    }
    return nil;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
            return 1;
            break;
        case 2:
            return 10;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DetailBannerATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailBannerATableViewCell"];
        if (!cell) {
            cell = [[DetailBannerATableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailBannerATableViewCell"];
        }
        return cell;
    }
    else if (indexPath.section == 1) {
        DetailBannerBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailBannerBTableViewCell"];
        if (!cell) {
            cell = [[DetailBannerBTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailBannerBTableViewCell"];
        }
        return cell;
    }
    else if (indexPath.section == 2) {
        DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailTableViewCell"];
        if (!cell) {
            cell = [[DetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailTableViewCell"];
            cell.delegate = self;
        }
        cell.index = indexPath.row;
        return cell;
    }
    return nil;
}

#pragma mark - DetailTableViewCellDelegate
- (void)didGoButtonSelectedWithIndex:(NSInteger)index {
    
}

#pragma mark - public method

#pragma mark - private method
- (void)_initView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"详情页-A";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (UIButton*)generateButton {
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
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
