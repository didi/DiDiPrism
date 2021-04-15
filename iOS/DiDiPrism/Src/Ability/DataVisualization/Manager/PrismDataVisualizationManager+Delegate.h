//
//  PrismDataVisualizationManager+Delegate.h
//  DiDiPrism
//
//  Created by hulk on 2021/3/30.
//

#import "PrismDataVisualizationManager.h"
// View
#import "PrismDataFloatingView.h"
// Component
#import "PrismDataFloatingMenuComponent.h"
#import "PrismDataFloatingComponent.h"
#import "PrismDataSwitchComponent.h"
#import "PrismDataFilterComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrismDataVisualizationManager (Delegate) <PrismDataFloatingMenuComponentDelegate, PrismDataSwitchComponentDelegate, PrismDataFilterComponentDelegate>

@end

NS_ASSUME_NONNULL_END
