//
//  UIScrollView+PrismIntercept.h
//  DiDiPrism
//
//  Created by hulk on 2021/8/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (PrismIntercept)

+ (void)prism_swizzleMethodIMP;
@end

NS_ASSUME_NONNULL_END
