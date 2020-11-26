//
//  PrismBehaviorDetectManager.h
//  DiDiPrism
//
//  Created by hulk on 2020/9/29.
//

#import <Foundation/Foundation.h>
#import "PrismBehaviorDetectRuleConfigModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrismBehaviorDetectManager : NSObject
+ (instancetype)sharedInstance;

/*
 加载配置，进入检测模式
 */
- (void)setupWithConfigModel:(PrismBehaviorDetectRuleConfigModel*)configModel;
/*
 传入行为指令进行实时行为检测
 */
- (void)addInstruction:(NSString*)instruction withParams:(NSDictionary*)params;
@end

NS_ASSUME_NONNULL_END
