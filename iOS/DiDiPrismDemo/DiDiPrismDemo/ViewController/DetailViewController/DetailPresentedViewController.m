//
//  DetailPresentedViewController.m
//  DiDiPrismDemo
//
//  Created by hulk on 2021/5/13.
//  Copyright © 2021 prism. All rights reserved.
//

#import "DetailPresentedViewController.h"
#import <Masonry/Masonry.h>

@interface DetailPresentedViewController ()

@end

@implementation DetailPresentedViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
}

#pragma mark - action
- (void)closeAction:(UIButton*)sender {
    [self.presentingViewController dismissViewControllerAnimated:self completion:nil];
}

#pragma mark - delegate

#pragma mark - public method

#pragma mark - private method
- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *closeButton = [[UIButton alloc] init];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [self.view addSubview:closeButton];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-15);
    }];
    
}


#pragma mark - setters

#pragma mark - getters

@end
