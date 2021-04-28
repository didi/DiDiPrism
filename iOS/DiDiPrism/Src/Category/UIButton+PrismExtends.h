//
//  UIButton+PrismExtends.h
//  DiDiPrism
//
//  Created by hulk on 2021/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (PrismExtends)
- (void)prism_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
@end

NS_ASSUME_NONNULL_END
