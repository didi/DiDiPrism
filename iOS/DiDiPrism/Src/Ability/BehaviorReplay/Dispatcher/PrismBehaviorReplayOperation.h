//
//  PrismBehaviorReplayOperation.h
//  DiDiPrism
//
//  Created by hulk on 2019/7/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrismBehaviorReplayOperation : NSOperation <NSCopying>
@property (nonatomic, strong) BOOL(^block)(BOOL isCompatibleMode, NSInteger index);
@property (nonatomic, assign) NSInteger index; //在所有步骤中的索引
@property (nonatomic, assign) float delaySeconds; //block执行完之后的等待时间。
@property (nonatomic, assign) float retryWaitSeconds; //重试时的间隔时间。
@property (nonatomic, assign) NSInteger retryTimes; //重试次数
@property (nonatomic, weak) NSOperationQueue *excuteQueue;
@property (nonatomic, assign) BOOL inWaiting; //是否已经在等待状态了
@end

NS_ASSUME_NONNULL_END
