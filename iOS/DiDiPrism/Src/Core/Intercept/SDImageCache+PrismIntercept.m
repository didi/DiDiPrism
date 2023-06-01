//
//  SDImageCache+PrismIntercept.m
//  DiDiPrism
//
//  Created by hulk on 2023/6/1.
//

#if __has_include(<SDWebImage/SDImageCache.h>)

#import "SDImageCache+PrismIntercept.h"
#import "PrismRuntimeUtil.h"
#import "UIImage+PrismIntercept.h"

@implementation SDImageCache (PrismIntercept)
#pragma mark - public method
+ (void)prism_swizzleMethodIMP {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(storeImage:imageData:forKey:toMemory:toDisk:completion:) swizzledSelector:@selector(prism_autoDot_storeImage:imageData:forKey:toMemory:toDisk:completion:)];
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(imageFromMemoryCacheForKey:) swizzledSelector:@selector(prism_autoDot_imageFromMemoryCacheForKey:)];
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(diskImageForKey:data:options:context:) swizzledSelector:@selector(prism_autoDot_diskImageForKey:data:options:context:)];

    });
}

#pragma mark - private method
- (void)prism_autoDot_storeImage:(nullable UIImage *)image
                       imageData:(nullable NSData *)imageData
                          forKey:(nullable NSString *)key
                        toMemory:(BOOL)toMemory
                          toDisk:(BOOL)toDisk
                      completion:(nullable SDWebImageNoParamsBlock)completionBlock {
    if (image && [image isKindOfClass:[UIImage class]] && key) {
        image.prismAutoDotImageUrl = key;
    }
    
    [self prism_autoDot_storeImage:image imageData:imageData forKey:key toMemory:toMemory toDisk:toDisk completion:completionBlock];
}

- (nullable UIImage *)prism_autoDot_imageFromMemoryCacheForKey:(nullable NSString *)key {
    UIImage *image = [self prism_autoDot_imageFromMemoryCacheForKey:key];
    if (image && [image isKindOfClass:[UIImage class]] && key) {
        image.prismAutoDotImageUrl = key;
    }
    return image;
}

- (nullable UIImage *)prism_autoDot_diskImageForKey:(nullable NSString *)key data:(nullable NSData *)data options:(SDImageCacheOptions)options context:(SDWebImageContext *)context {
    UIImage *image = [self prism_autoDot_diskImageForKey:key data:data options:options context:context];
    if (image && [image isKindOfClass:[UIImage class]] && key) {
        image.prismAutoDotImageUrl = key;
    }
    return image;
}
@end

#endif
