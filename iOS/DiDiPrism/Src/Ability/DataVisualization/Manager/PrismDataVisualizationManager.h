//
//  PrismDataVisualizationManager.h
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import <Foundation/Foundation.h>
// Component
#import "PrismDataBaseComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrismDataVisualizationManager : NSObject
+ (instancetype)sharedManager;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, strong, readonly) NSMutableArray<PrismDataBaseComponent*> *allComponents;

/*
 初始化
 */
- (void)install;
- (void)uninstall;

- (void)registerComponent:(PrismDataBaseComponent*)component;
- (void)unregisterComponent:(PrismDataBaseComponent*)component;
@end

NS_ASSUME_NONNULL_END
