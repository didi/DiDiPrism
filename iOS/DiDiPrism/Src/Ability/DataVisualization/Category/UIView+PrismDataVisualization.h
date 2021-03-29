//
//  UIView+PrismDataVisualization.h
//  DiDiPrism
//
//  Created by hulk on 2021/3/29.
//

#import <UIKit/UIKit.h>
#import "PrismElementRelatedInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (PrismDataVisualization)
/*
 元素的关联信息
 */
@property (nonatomic, strong) PrismElementRelatedInfos *relatedInfos;
@end

NS_ASSUME_NONNULL_END
