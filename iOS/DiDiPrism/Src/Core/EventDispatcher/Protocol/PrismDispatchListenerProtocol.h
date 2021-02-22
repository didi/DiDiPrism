//
//  PrismDispatchListenerProtocol.h
//  DiDiPrism
//
//  Created by didi on 2021/2/22.
//

#import <Foundation/Foundation.h>
#import "PrismDispatchEventDefine.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PrismDispatchListenerProtocol <NSObject>

- (void)dispatchEvent:(PrismDispatchEvent)event withSender:(NSObject *)sender params:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
