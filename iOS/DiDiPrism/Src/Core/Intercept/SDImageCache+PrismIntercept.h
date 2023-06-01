//
//  SDImageCache+PrismIntercept.h
//  DiDiPrism
//
//  Created by hulk on 2023/6/1.
//

#if __has_include(<SDWebImage/SDImageCache.h>)

#import <SDWebImage/SDImageCache.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDImageCache (PrismIntercept)
+ (void)prism_swizzleMethodIMP;
@end

NS_ASSUME_NONNULL_END

#endif
