//
//  WebViewController.m
//  DiDiPrismDemo
//
//  Created by didi on 2021/1/5.
//  Copyright © 2021 prism. All rights reserved.
//

#import "WebViewController.h"
#import "Masonry.h"
#import <WebKit/WebKit.h>

@interface WebViewController () <WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation WebViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
}

#pragma mark - action

#pragma mark - delegate

#pragma mark - public method

#pragma mark - private method
- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"WebView";
    
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]]];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - setters

#pragma mark - getters
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:[[WKWebViewConfiguration alloc] init]];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.allowsBackForwardNavigationGestures = YES;
    }
    return _webView;
}
@end
