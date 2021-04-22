//
//  PrismDataFilterComponent.h
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import "PrismDataBaseComponent.h"
// Model
#import "PrismDataFilterItem.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PrismDataFilterComponentDelegate <PrismDataBaseComponentDelegate>

- (void)filterDataWithConfig:(NSArray<PrismDataFilterItemConfig*>*)config;
- (void)foldAllComponent:(BOOL)isFolding;

@end

@interface PrismDataFilterComponent : PrismDataBaseComponent
@property (nonatomic, copy) NSArray<PrismDataFilterItemConfig*> *config;
@end

NS_ASSUME_NONNULL_END
