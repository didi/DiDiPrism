//
//  PrismEventDispatcher.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import "PrismEventDispatcher.h"

@interface PrismEventDispatcher()
@property (nonatomic, strong) NSMutableArray<id<PrismDispatchListenerProtocol>> *allListeners;
@property (nonatomic, strong) dispatch_queue_t syncQueue;
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

- (instancetype)init {
    self = [super init];
    if (self) {
        _syncQueue = dispatch_queue_create("com.prism.eventdispatcher.queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

#pragma mark - public method
- (void)registerListener:(id<PrismDispatchListenerProtocol>)listener {
    if (!listener) {
        return;
    }
    dispatch_sync(self.syncQueue, ^{
        if (![self.allListeners containsObject:listener]) {
            [self.allListeners addObject:listener];
        }
    });
}

- (void)unregisterListener:(id<PrismDispatchListenerProtocol>)listener {
    if (!listener) {
        return;
    }
    dispatch_sync(self.syncQueue, ^{
        [self.allListeners removeObject:listener];
    });
}

- (void)dispatchEvent:(PrismDispatchEvent)event withSender:(NSObject*)sender params:(nullable NSDictionary*)params {
    __block NSArray<id<PrismDispatchListenerProtocol>> *listenersCopy = nil;
    dispatch_sync(self.syncQueue, ^{
        listenersCopy = [self.allListeners copy];
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<PrismDispatchListenerProtocol> listener in listenersCopy) {
            [listener dispatchEvent:event withSender:sender params:params];
        }
    });
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
