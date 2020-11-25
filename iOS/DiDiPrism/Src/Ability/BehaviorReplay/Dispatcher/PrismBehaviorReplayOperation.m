//
//  PrismBehaviorReplayOperation.m
//  DiDiPrism
//
//  Created by hulk on 2019/7/29.
//

#import "PrismBehaviorReplayOperation.h"
#import "PrismBehaviorReplayManager.h"

@interface PrismBehaviorReplayOperation()
@property (nonatomic, assign) BOOL isCompleted;
@property (nonatomic, assign) NSInteger retryCount;
@end

@implementation PrismBehaviorReplayOperation
#pragma mark - life cycle

#pragma mark - override method
- (void)start {
    if (self.cancelled) {
        self.isCompleted = YES;
    }
    [super start];
}

- (void)main {
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL isSucceed = NO;
        if (self.block) {
            isSucceed = self.block(NO, self.index);
            if (!isSucceed && self.excuteQueue) {
                BOOL isLastInstructionParseFail = [PrismBehaviorReplayManager sharedManager].isLastInstructionParseFail;
                if (self.retryCount >= self.retryTimes || (self.retryCount == 0 && isLastInstructionParseFail)) {
                    NSLog(@"Prism Retry Fail");
                    //兜底的兼容模式
                    isSucceed = self.block(YES, self.index);
                    [PrismBehaviorReplayManager sharedManager].isLastInstructionParseFail = !isSucceed;
                    if (!isSucceed) {
                        [PrismBehaviorReplayManager sharedManager].continuousFailCount++;
                    }
                    else {
                        [PrismBehaviorReplayManager sharedManager].continuousFailCount = 0;
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delaySeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self willChangeValueForKey:@"isFinished"];
                        self.isCompleted = YES;
                        [self didChangeValueForKey:@"isFinished"];
                    });
                    
                    return;
                }
                self.retryCount++;
                NSMutableArray<NSOperation*> *operationArray = [NSMutableArray array];
                [self.excuteQueue.operations enumerateObjectsUsingBlock:^(__kindof NSOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[PrismBehaviorReplayOperation class]]) {
                        [obj cancel];
                        [operationArray addObject:[obj copy]];
                    }
                }];
                for (NSOperation *operaion in operationArray) {
                    [self.excuteQueue addOperation:operaion];
                }
                
            }
        }
        float delaySeconds = isSucceed ? self.delaySeconds : self.retryWaitSeconds;
        self.inWaiting = isSucceed;
        [PrismBehaviorReplayManager sharedManager].isLastInstructionParseFail = !isSucceed;
        if (isSucceed) {
            [PrismBehaviorReplayManager sharedManager].continuousFailCount = 0;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self willChangeValueForKey:@"isFinished"];
            self.isCompleted = YES;
            [self didChangeValueForKey:@"isFinished"];
            self.inWaiting = NO;
        });
    });
}

- (BOOL)isFinished {
    return self.isCompleted;
}

#pragma mark - public method
- (id)copyWithZone:(NSZone *)zone {
    PrismBehaviorReplayOperation *newOperation = [[PrismBehaviorReplayOperation alloc] init];
    newOperation.block = self.block;
    newOperation.index = self.index;
    newOperation.retryTimes = self.retryTimes;
    newOperation.retryWaitSeconds = self.retryWaitSeconds;
    newOperation.delaySeconds = self.delaySeconds;
    newOperation.excuteQueue = self.excuteQueue;
    newOperation.retryCount = self.retryCount;
    newOperation.inWaiting = self.inWaiting;
    return newOperation;
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
