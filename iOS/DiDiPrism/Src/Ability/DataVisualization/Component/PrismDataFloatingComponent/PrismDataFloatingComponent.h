//
//  PrismDataFloatingComponent.h
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import "PrismDataBaseComponent.h"
// View
#import "PrismDataFloatingView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrismDataFloatingComponent : PrismDataBaseComponent
- (NSMutableArray<PrismDataFloatingView *> *)allFloatingViews;
@end

NS_ASSUME_NONNULL_END
