//
//  UIView+PrismIntercept.h
//  DiDiPrism
//
//  Created by hulk on 2019/7/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (PrismIntercept)

+ (void)prism_swizzleMethodIMP;
@end

NS_ASSUME_NONNULL_END
