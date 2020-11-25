//
//  PrismBehaviorReplayManager.h
//  DiDiPrism
//
//  Created by hulk on 2019/7/18.
//

#import <Foundation/Foundation.h>
#import "PrismBehaviorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrismBehaviorReplayManager : NSObject
+ (instancetype)sharedManager;

@property (nonatomic, assign) NSInteger currentReplayIndex; //当前正在回放的指令索引
@property (nonatomic, assign) BOOL isLastInstructionParseFail;
@property (nonatomic, assign) NSInteger continuousFailCount; //连续失败计数，不考虑同一指令重试

- (void)startWithModel:(PrismBehaviorListModel *)model
         progressBlock:(void (^)(NSInteger,NSString*))progressBlock
       completionBlock:(void (^)(void))completionBlock;
- (void)goon;
- (void)pause;
- (void)stop;
@end

NS_ASSUME_NONNULL_END
