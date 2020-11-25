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

- (void)setupWithConfigModel:(PrismBehaviorDetectRuleConfigModel*)configModel;
- (void)addInstruction:(NSString*)instruction withParams:(NSDictionary*)params;
@end

NS_ASSUME_NONNULL_END
