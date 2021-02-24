//
//  UIColor+PrismExtends.h
//  DiDiPrism
//
//  Created by hulk on 2020/10/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (PrismExtends)
+ (UIColor *)prism_colorWithHexString:(NSString *)hexString;
+ (UIColor *)prism_colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;
@end

NS_ASSUME_NONNULL_END
