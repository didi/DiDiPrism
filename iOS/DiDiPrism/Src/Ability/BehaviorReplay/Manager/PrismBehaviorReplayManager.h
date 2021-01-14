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
@property (nonatomic, copy, readonly) NSArray<PrismBehaviorItemRequestInfoModel*> *currentReplayRequestInfos; //当前正在回放的指令关联的网络信息
@property (nonatomic, strong) NSString*(^urlFlagPickBlock)(NSURLRequest*); //定制用于匹配网络请求信息的逻辑。
@property (nonatomic, assign) BOOL isLastInstructionParseFail;
@property (nonatomic, assign) NSInteger continuousFailCount; //连续失败计数，不考虑同一指令重试

/*
 开始回放
 */
- (void)startWithModel:(PrismBehaviorListModel *)model
         progressBlock:(void (^)(NSInteger,NSString*))progressBlock
       completionBlock:(void (^)(void))completionBlock;
/*
 继续回放
 */
- (void)goon;
/*
 暂停回放
 */
- (void)pause;
/*
 结束回放
 */
- (void)stop;
@end

NS_ASSUME_NONNULL_END
