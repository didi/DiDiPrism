//
//  PrismDataFloatingMenuComponent.h
//  DiDiPrism
//
//  Created by hulk on 2021/2/23.
//

#import "PrismDataBaseComponent.h"
// Model
#import "PrismDataFloatingMenuItemConfig.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PrismDataFloatingMenuComponentDelegate <PrismDataBaseComponentDelegate>

- (UIView*)matchViewWithTapGesture:(UITapGestureRecognizer*)tapGesture;
- (void)menuDidAppearWithTouchedView:(UIView*)touchedView;
- (void)menuDidDisappearWithTouchedView:(UIView*)touchedView;
@end

@interface PrismDataFloatingMenuComponent : PrismDataBaseComponent
- (void)setupWithConfig:(NSArray<PrismDataFloatingMenuItemConfig*>*)config;
@end

NS_ASSUME_NONNULL_END
