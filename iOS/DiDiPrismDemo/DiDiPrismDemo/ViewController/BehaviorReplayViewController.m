//
//  HomeViewController.m
//  DiDiPrismDemo
//
//  Created by hulk on 2020/9/4.
//  Copyright © 2020 prism. All rights reserved.
//

#import "BehaviorReplayViewController.h"
// ViewController
#import "DetailViewController.h"
// Model
#import "PrismBehaviorModel.h"
// Category
#import "NSDictionary+PrismExtends.h"
// Manager
#import "PrismBehaviorReplayManager.h"
#import "PrismBehaviorRecordManager.h"
// View
#import "BehaviorTextDescView.h"
#import "BehaviorReplayOperationView.h"

@interface BehaviorReplayViewController () <BehaviorReplayOperationViewDelegate>
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, strong) NSMutableArray<PrismBehaviorItemModel*> *itemModels;
@property (nonatomic, strong) UIButton *operationButton;
@property (nonatomic, strong) UIButton *videoReplayButton;
@property (nonatomic, strong) UIButton *textReplayButton;
@property (nonatomic, strong) UIView *seperatorLine;
@property (nonatomic, strong) BehaviorReplayOperationView *operationView;
@end

@implementation BehaviorReplayViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[PrismBehaviorRecordManager sharedManager] setup];
    [[PrismBehaviorReplayManager sharedManager] setup];
    [self _addNotification];
    [self _initView];
}

#pragma mark - action
- (void)newInstructionNotification:(NSNotification*)notification {
    if (!self.isRecording) {
        return;
    }
    PrismBehaviorItemModel *itemModel = [[PrismBehaviorItemModel alloc] init];
    itemModel.instruction = [notification.userInfo prism_stringForKey:@"instruction"];
    itemModel.eventTime = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    [self.itemModels addObject:itemModel];
}

- (void)replayStopNotification:(NSNotification*)notification {
    [self.operationView removeFromSuperview];
}

- (void)operateAction:(UIButton*)sender {
    self.isRecording = !self.isRecording;
    [sender setTitle:self.isRecording ? @"结束录制" : @"开始录制" forState:UIControlStateNormal];
    self.videoReplayButton.enabled = !self.isRecording;
    self.textReplayButton.enabled = !self.isRecording;
    if (self.isRecording) {
        [self.itemModels removeAllObjects];
    }
}

- (void)videoReplayAction:(UIButton*)sender {
    if (!self.itemModels.count) {
        return;
    }
    PrismBehaviorListModel *listModel = [[PrismBehaviorListModel alloc] init];
    listModel.instructions = [self.itemModels copy];
    UIWindow *mainWindow = UIApplication.sharedApplication.delegate.window;
    self.operationView = [[BehaviorReplayOperationView alloc] initWithFrame:CGRectMake(0, 44, mainWindow.frame.size.width, 25)];
    self.operationView.delegate = self;
    [mainWindow addSubview:self.operationView];
    self.operationView.model = listModel;
    [[PrismBehaviorReplayManager sharedManager] startWithModel:listModel progressBlock:^(NSInteger index, NSString * _Nonnull instruction) {
        
    } completionBlock:^{
        [self.operationView removeFromSuperview];
    }];
}

- (void)textReplayAction:(UIButton*)sender {
    if (!self.itemModels.count) {
        return;
    }
    PrismBehaviorListModel *listModel = [[PrismBehaviorListModel alloc] init];
    listModel.instructions = [self.itemModels copy];
    UIWindow *mainWindow = UIApplication.sharedApplication.delegate.window;
    BehaviorTextDescView *textDescView = [[BehaviorTextDescView alloc] initWithFrame:CGRectMake(0, 0, mainWindow.frame.size.width, mainWindow.frame.size.height)];
    textDescView.model = listModel;
    [mainWindow addSubview:textDescView];
}

#pragma mark - delegate
#pragma mark BehaviorReplayOperationViewDelegate
- (void)didGoonButtonSelected {
    [[PrismBehaviorReplayManager sharedManager] goon];
}

- (void)didPauseButtonSelected {
    [[PrismBehaviorReplayManager sharedManager] pause];
}

- (void)didStopButtonSelected {
    [[PrismBehaviorReplayManager sharedManager] stop];
}

#pragma mark - private method
- (void)_addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newInstructionNotification:) name:@"prism_new_instruction_notification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replayStopNotification:) name:@"prism_behaviorreplay_stop_notification" object:nil];
}

- (void)_initView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"行为回放演示";
    
    [self.view addSubview:self.operationButton];
    [self.view addSubview:self.videoReplayButton];
    [self.view addSubview:self.textReplayButton];
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

#pragma mark - getter
- (NSMutableArray<PrismBehaviorItemModel *> *)itemModels {
    if (!_itemModels) {
        _itemModels = [NSMutableArray array];
    }
    return _itemModels;
}

- (UIButton *)operationButton {
    if (!_operationButton) {
        _operationButton = [self generateButton];
        _operationButton.frame = CGRectMake(20, 110, 100, 40);
        [_operationButton setTitle:@"开始录制" forState:UIControlStateNormal];
        [_operationButton addTarget:self action:@selector(operateAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _operationButton;
}

- (UIButton *)videoReplayButton {
    if (!_videoReplayButton) {
        _videoReplayButton = [self generateButton];
        _videoReplayButton.frame = CGRectMake(170, 110, 100, 40);
        [_videoReplayButton setTitle:@"视频回放" forState:UIControlStateNormal];
        [_videoReplayButton setImage:[UIImage imageNamed:@"replay_play@3x"] forState:UIControlStateNormal];
        [_videoReplayButton addTarget:self action:@selector(videoReplayAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoReplayButton;
}

- (UIButton *)textReplayButton {
    if (!_textReplayButton) {
        _textReplayButton = [self generateButton];
        _textReplayButton.frame = CGRectMake(280, 110, 100, 40);
        [_textReplayButton setTitle:@"文字回放" forState:UIControlStateNormal];
        [_textReplayButton setImage:[UIImage imageNamed:@"replay_text@3x"] forState:UIControlStateNormal];
        [_textReplayButton addTarget:self action:@selector(textReplayAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _textReplayButton;
}

- (UIView *)seperatorLine {
    if (!_seperatorLine) {
        _seperatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 169, self.view.frame.size.width, 0.5)];
        _seperatorLine.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    }
    return _seperatorLine;
}
@end
