//
//  UIGestureRecognizer+PrismIntercept.h
//  DiDiPrism
//
//  Created by hulk on 2025/2/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIGestureRecognizer (PrismIntercept)

+ (void)prism_swizzleMethodIMP;

@end

NS_ASSUME_NONNULL_END
