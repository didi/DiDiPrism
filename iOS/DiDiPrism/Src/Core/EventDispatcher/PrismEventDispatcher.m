//
//  PrismEventDispatcher.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import "PrismEventDispatcher.h"

@interface PrismEventDispatcher()
@property (nonatomic, strong) NSMutableArray<id<PrismDispatchListenerProtocol>> *allListeners;
@end

@implementation PrismEventDispatcher
#pragma mark - life cycle
+ (instancetype)sharedInstance {
    static PrismEventDispatcher *dispatcher = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatcher = [[PrismEventDispatcher alloc] init];
    });
    return dispatcher;
}

#pragma mark - public method
- (void)registerListener:(id<PrismDispatchListenerProtocol>)listener {
    if (!listener) {
        return;
    }
    if (![self.allListeners containsObject:listener]) {
        [self.allListeners addObject:listener];
    }
}

- (void)unregisterListener:(id<PrismDispatchListenerProtocol>)listener {
    if (!listener) {
        return;
    }
    [self.allListeners removeObject:listener];
}

- (void)dispatchEvent:(PrismDispatchEvent)event withSender:(NSObject*)sender params:(nullable NSDictionary*)params {
    NSArray<id<PrismDispatchListenerProtocol>> *listeners = [self.allListeners copy];
    for (id<PrismDispatchListenerProtocol> listener in listeners) {
        [listener dispatchEvent:event withSender:sender params:params];
    }
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters
- (NSMutableArray<id<PrismDispatchListenerProtocol>> *)allListeners {
    if (!_allListeners) {
        _allListeners = [NSMutableArray array];
    }
    return _allListeners;
}
@end
