//
//  PrismEngine.h
//  DiDiPrism
//
//  Created by hulk on 2021/6/30.
//

#import <Foundation/Foundation.h>
#import "PrismDispatchEventDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrismEngine : NSObject
+ (void)startEngineWithEventCategorys:(PrismEventCategory)eventCategorys;
@end

NS_ASSUME_NONNULL_END
