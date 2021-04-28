//
//  PrismDataPickerView.h
//  DiDiPrism
//
//  Created by hulk on 2021/3/30.
//

#import <UIKit/UIKit.h>
// Model
#import "PrismDataFilterItem.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PrismDataPickerViewDelegate <NSObject>
@optional
- (void)confirmWithSelectedRow:(NSInteger)selectedRow;
- (void)confirmWithSelectedRow0:(NSInteger)selectedRow0 selectedRow1:(NSInteger)selectedRow1;

@end

@interface PrismDataPickerView : UIView
@property (nonatomic, weak) id<PrismDataPickerViewDelegate> delegate;

- (void)reloadWithAllItems:(NSArray<PrismDataFilterItem*> *)allItems defaultRow:(NSInteger)defaultRow;
- (void)reloadWithAllItems:(NSDictionary<NSString*,NSArray<PrismDataFilterItem*>*> *)allItems
               defaultRow0:(NSInteger)defaultRow0
               defaultRow1:(NSInteger)defaultRow1;
@end

NS_ASSUME_NONNULL_END
