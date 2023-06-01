//
//  UIImage+PrismIntercept.h
//  DiDiPrism
//
//  Created by hulk on 2019/6/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (PrismIntercept)

@property (nonatomic, copy) NSString *prismAutoDotImageName;
@property (nonatomic, copy) NSString *prismAutoDotImageUrl;

+ (void)prism_swizzleMethodIMP;
@end

NS_ASSUME_NONNULL_END
