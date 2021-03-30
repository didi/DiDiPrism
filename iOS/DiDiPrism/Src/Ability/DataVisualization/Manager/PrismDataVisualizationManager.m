//
//  PrismDataVisualizationManager.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import "PrismDataVisualizationManager.h"
#import "PrismEventDispatcher.h"

@interface PrismDataVisualizationManager()
@property (nonatomic, strong) NSMutableArray<PrismDataBaseComponent*> *allComponents;
@end

@implementation PrismDataVisualizationManager
#pragma mark - life cycle
+ (instancetype)sharedManager {
    static PrismDataVisualizationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PrismDataVisualizationManager alloc] init];
    });
    return manager;
}

#pragma mark - public method
- (void)setup {
    [[PrismEventDispatcher sharedInstance] registerListener:(id<PrismDispatchListenerProtocol>)self];
}

- (void)registerComponent:(PrismDataBaseComponent*)component {
    if (!component) {
        return;
    }
    if (![self.allComponents containsObject:component]) {
        component.delegate = self;
        [self.allComponents addObject:component];
    }
}

- (void)unregisterComponent:(PrismDataBaseComponent*)component {
    if (!component) {
        return;
    }
    [self.allComponents removeObject:component];
}

#pragma mark - private method

#pragma mark - setters
- (void)setEnable:(BOOL)enable {
    _enable = enable;
    for (PrismDataBaseComponent *component in self.allComponents) {
        component.enable = _enable;
    }
}

#pragma mark - getters
- (NSMutableArray<PrismDataBaseComponent *> *)allComponents {
    if (!_allComponents) {
        _allComponents = [NSMutableArray array];
    }
    return _allComponents;
}
@end
