//
//  UITextField+PrismIntercept.h
//  DiDiPrism
//
//  Created by hulk on 2022/4/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (PrismIntercept)

+ (void)prism_swizzleMethodIMP;
@end

NS_ASSUME_NONNULL_END
