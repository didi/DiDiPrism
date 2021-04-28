//
//  PrismDataFloatingView.h
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import <UIKit/UIKit.h>
#import "PrismDataFloatingModel.h"

NS_ASSUME_NONNULL_BEGIN

#define MinWidthOfPrismDataFloatingView 60
#define MinHeightOfPrismDataFloatingView 30

typedef NS_ENUM(NSUInteger, PrismDataFloatingViewMode) {
    PrismDataFloatingViewModeNormal,
    PrismDataFloatingViewModeSelected,
    PrismDataFloatingViewModeNoText
};

@interface PrismDataFloatingView : UIView
@property (nonatomic, assign) PrismDataFloatingViewMode showMode;
@property (nonatomic, strong) PrismDataFloatingModel *model;
@property (nonatomic, assign) BOOL heatMapEnable;
@end

NS_ASSUME_NONNULL_END
