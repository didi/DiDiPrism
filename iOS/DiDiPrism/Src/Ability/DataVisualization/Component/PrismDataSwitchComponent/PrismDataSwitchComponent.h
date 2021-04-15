//
//  PrismDataSwitchComponent.h
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import "PrismDataBaseComponent.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PrismDataSwitchComponentMode) {
    PrismDataSwitchComponentDataMode,
    PrismDataSwitchComponentHeatMode
};

@protocol PrismDataSwitchComponentDelegate <PrismDataBaseComponentDelegate>

- (void)switchToMode:(PrismDataSwitchComponentMode)mode;

@end

@interface PrismDataSwitchComponent : PrismDataBaseComponent
- (void)handleView:(BOOL)isHidden;
@end

NS_ASSUME_NONNULL_END
