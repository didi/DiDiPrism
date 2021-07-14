//
//  UIViewController+PrismIntercept.h
//  DiDiPrism
//
//  Created by hulk on 2019/8/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (PrismIntercept)

+ (void)prism_swizzleMethodIMP;
@end

NS_ASSUME_NONNULL_END
