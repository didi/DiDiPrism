//
//  PrismBehaviorReplayManager.m
//  DiDiPrism
//
//  Created by hulk on 2019/7/18.
//

#import "PrismBehaviorReplayManager.h"
#import "PrismBaseInstructionParser.h"
#import "PrismBehaviorReplayOperation.h"
#import "PrismBehaviorRecordManager.h"
#import "PrismInstructionDefines.h"

@interface PrismBehaviorReplayManager()
@property (nonatomic, strong) NSOperationQueue *prismOperationQueue;
@property (nonatomic, copy) NSArray<NSOperation*> *remainingOperationArray;
@property (nonatomic, copy) void(^progressBlock)(NSInteger,NSString*);
@property (nonatomic, copy) void(^allCompletionBlock)(void);

@property (nonatomic, strong) PrismBehaviorListModel *model;
@end

@implementation PrismBehaviorReplayManager
#pragma mark - life cycle
+ (instancetype)sharedManager {
    static PrismBehaviorReplayManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[PrismBehaviorReplayManager alloc] init];
        }
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.currentReplayIndex = -1;
    }
    return self;
}

#pragma mark - public method
- (void)startWithModel:(PrismBehaviorListModel *)model
         progressBlock:(void (^)(NSInteger,NSString*))progressBlock
       completionBlock:(void (^)(void))completionBlock {
    [PrismBehaviorRecordManager sharedInstance].isInReplaying = YES;
    self.model = model;
    NSArray<PrismBehaviorVideoModel*> *behaviorArray = [model.instructionArray subarrayWithRange:NSMakeRange(model.startIndex, MIN(model.endIndex + 1, model.instructionArray.count) - model.startIndex)];
    if (!behaviorArray.count) {
        UILabel *promptLabel = [[UILabel alloc] init];
        [self showPromptView:promptLabel withText:@"找不到回放起点"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [promptLabel removeFromSuperview];
        });
        if (completionBlock) {
            completionBlock();
        }
        return;
    }
    
    self.progressBlock = progressBlock;
    self.allCompletionBlock = completionBlock;
    [self replayWithBehaviorArray:behaviorArray withStartIndex:0];
}

- (void)goon {
    [PrismBehaviorRecordManager sharedInstance].isInReplaying = YES;
    NSOperationQueue *behaviorOperationQueue = self.prismOperationQueue;
    for (NSOperation *operaion in self.remainingOperationArray) {
        [behaviorOperationQueue addOperation:operaion];
    }
}

- (void)pause {
    [PrismBehaviorRecordManager sharedInstance].isInReplaying = NO;
    self.currentReplayIndex = -1;
    NSMutableArray<NSOperation*> *operationArray = [NSMutableArray array];
    NSOperationQueue *behaviorOperationQueue = self.prismOperationQueue;
    [behaviorOperationQueue.operations enumerateObjectsUsingBlock:^(__kindof NSOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PrismBehaviorReplayOperation class]]) {
            [obj cancel];
            [operationArray addObject:[obj copy]];
        }
    }];
    // 已经执行过的就不再执行了
    if (((PrismBehaviorReplayOperation*)operationArray.firstObject).inWaiting) {
        [operationArray removeObjectAtIndex:0];
    }
    self.remainingOperationArray = [operationArray copy];
}

- (void)stop {
    [PrismBehaviorRecordManager sharedInstance].isInReplaying = NO;
    self.currentReplayIndex = -1;
    NSOperationQueue *behaviorOperationQueue = self.prismOperationQueue;
    [behaviorOperationQueue.operations enumerateObjectsUsingBlock:^(__kindof NSOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PrismBehaviorReplayOperation class]]) {
            [obj cancel];
        }
    }];
}

#pragma mark - private method
- (void)replayWithBehaviorArray:(NSArray<PrismBehaviorVideoModel*>*)behaviorArray withStartIndex:(NSInteger)startIndex {
    self.continuousFailCount = 0;
    
    UILabel *promptLabel = [[UILabel alloc] init];
    if (startIndex > 0) {
        [self showPromptView:promptLabel withText:@"初始状态还原中，请稍等.."];
    }
    
    NSOperationQueue *behaviorOperationQueue = self.prismOperationQueue;
    behaviorOperationQueue.maxConcurrentOperationCount = 1;
    NSInteger index = 0;
    for (PrismBehaviorVideoModel *theOne in behaviorArray) {
        NSString *behaviorInstruction = theOne.instruction;
        NSString *behaviorTime = theOne.descTime.length ? theOne.descTime : @"";
        if ([behaviorInstruction containsString:kUIViewControllerDidAppear]) {
            index++;
            continue;
        }
        PrismBehaviorReplayOperation *behaviorOperation = [[PrismBehaviorReplayOperation alloc] init];
        behaviorOperation.index = index;
        behaviorOperation.retryTimes = 2;
        behaviorOperation.retryWaitSeconds = 1;
        behaviorOperation.delaySeconds = 3;
        behaviorOperation.excuteQueue = behaviorOperationQueue;
        __weak typeof(self) weakSelf = self;
        behaviorOperation.block = ^BOOL(BOOL isCompatibleMode, NSInteger index) {
            if (weakSelf.continuousFailCount > 2) {
                [weakSelf stop];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"prism_behaviorreplay_stop_notification" object:nil userInfo:nil];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"回放失败，建议查看文字回放" message:@"由于您当前页面状态与用户当时的页面状态差距过大导致回放失败，建议您查看对应的文字回放内容作为参考。" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertController addAction:okAction];
                UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
                [mainWindow.rootViewController presentViewController:alertController animated:YES completion:^{
                    
                }];
                return YES;
            }
            NSString *executedBehaviorInstruction = behaviorInstruction;
            if (index == startIndex) {
                promptLabel.text = @"准备就绪，开始播放";
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [promptLabel removeFromSuperview];
                });
            }
            
            PrismInstructionParseResult parseResult = PrismInstructionParseResultFail;
            PrismBaseInstructionParser *instructionParser = [PrismBaseInstructionParser instructionParserWithFormatter:theOne.instructionFormatter];
            instructionParser.isCompatibleMode = isCompatibleMode;
            if (index == behaviorArray.count - 1) {
                instructionParser.needExecute = NO;
            }
            parseResult = [instructionParser parseWithFormatter:theOne.instructionFormatter];
            
            weakSelf.currentReplayIndex = weakSelf.model.startIndex + index;
            if (weakSelf.progressBlock) {
                weakSelf.progressBlock(index, executedBehaviorInstruction);
            }
            
            if (parseResult == PrismInstructionParseResultFail) {
                NSLog(@"Prism Fail: %@", executedBehaviorInstruction);
                if (!weakSelf.isLastInstructionParseFail) {
                    weakSelf.model.replayFailIndex = index;
                }
                NSInteger dotCount = random() % 3;
                NSString *stateText = dotCount == 0 ? @"重试中" : (dotCount == 1 ? @"重试中." : @"重试中..");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"prism_behaviorreplay_statechanged_notification" object:nil userInfo:@{@"state":stateText}];
                return NO;
            }
            else if (parseResult == PrismInstructionParseResultError) {
                NSLog(@"Prism Error: %@", executedBehaviorInstruction);
                weakSelf.model.replayFailIndex = -1;
                return YES;
            }
            else {
                NSLog(@"Prism Success: %@", executedBehaviorInstruction);
                weakSelf.model.replayFailIndex = -1;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"prism_behaviorreplay_statechanged_notification" object:nil userInfo:@{@"state":@"回放中.."}];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"prism_behaviorreplay_timechanged_notification" object:nil userInfo:@{@"time":behaviorTime}];
                return YES;
            }
        };
        [behaviorOperationQueue addOperation:behaviorOperation];
        index++;
    }
    
    __weak typeof(self) weakSelf = self;
    PrismBehaviorReplayOperation *endOperation = [[PrismBehaviorReplayOperation alloc] init];
    endOperation.excuteQueue = behaviorOperationQueue;
    endOperation.block = ^BOOL(BOOL isCompatibleMode, NSInteger index) {
        weakSelf.model.replayFailIndex = -1;
        if (weakSelf.allCompletionBlock) {
            weakSelf.allCompletionBlock();
        }
        [weakSelf showPromptView:promptLabel withText:@"回放结束"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [promptLabel removeFromSuperview];
        });
        return YES;
    };
    [behaviorOperationQueue addOperation:endOperation];
}

- (void)showPromptView:(UILabel*)promptLabel withText:(NSString*)text {
    UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
    promptLabel.font = [UIFont boldSystemFontOfSize:35];
    promptLabel.textColor = [UIColor redColor];
    promptLabel.text = text;
    [promptLabel sizeToFit];
    promptLabel.frame = CGRectMake((mainWindow.frame.size.width - promptLabel.frame.size.width)/2, (mainWindow.frame.size.height - promptLabel.frame.size.height)/2, promptLabel.frame.size.width, promptLabel.frame.size.height);
    [mainWindow addSubview:promptLabel];
}

#pragma mark - setters

#pragma mark - getters
- (NSOperationQueue *)prismOperationQueue {
    if (!_prismOperationQueue) {
        _prismOperationQueue = [[NSOperationQueue alloc] init];
        _prismOperationQueue.maxConcurrentOperationCount = 1;
    }
    return _prismOperationQueue;
}

@end
