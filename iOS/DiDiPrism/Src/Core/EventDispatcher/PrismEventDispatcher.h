//
//  PrismEventDispatcher.h
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import <Foundation/Foundation.h>
#import "PrismDispatchEventDefine.h"
#import "PrismDispatchListenerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrismEventDispatcher : NSObject
+ (instancetype)sharedInstance;

- (void)registerListener:(id<PrismDispatchListenerProtocol>)listener;
- (void)unregisterListener:(id<PrismDispatchListenerProtocol>)listener;
- (void)dispatchEvent:(PrismDispatchEvent)event withSender:(NSObject*)sender params:(nullable NSDictionary*)params;
@end

NS_ASSUME_NONNULL_END
