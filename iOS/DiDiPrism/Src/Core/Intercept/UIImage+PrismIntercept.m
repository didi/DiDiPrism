//
//  UIImage+PrismIntercept.m
//  DiDiPrism
//
//  Created by hulk on 2019/6/27.
//

#import "UIImage+PrismIntercept.h"
#import <objc/runtime.h>
#import <RSSwizzle/RSSwizzle.h>

@implementation UIImage (PrismIntercept)
#pragma mark - public method
+ (void)prism_swizzleMethodIMP {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Swizzle imageNamed:
        RSSwizzleClassMethod(UIImage, @selector(imageNamed:),
                                RSSWReturnType(UIImage *),
                                RSSWArguments(NSString *name),
                                RSSWReplacement({
            UIImage *image = RSSWCallOriginal(name);
            image.prismAutoDotImageName = [self getImageNameFromPath:name];
            return image;
        })
                            );
        
#if __has_include(<UIKit/UITraitCollection.h>)
        // Swizzle imageNamed:inBundle:compatibleWithTraitCollection:
        RSSwizzleClassMethod(UIImage, @selector(imageNamed:inBundle:compatibleWithTraitCollection:),
                                RSSWReturnType(UIImage *),
                                RSSWArguments(NSString *name, NSBundle *bundle, UITraitCollection *traitCollection),
                                RSSWReplacement({
            UIImage *image = RSSWCallOriginal(name, bundle, traitCollection);
            image.prismAutoDotImageName = [self getImageNameFromPath:name];
            return image;
        })
                            );
#endif
        
        // Swizzle imageWithContentsOfFile:
        RSSwizzleClassMethod(UIImage, @selector(imageWithContentsOfFile:),
                                RSSWReturnType(UIImage *),
                                RSSWArguments(NSString *path),
                                RSSWReplacement({
            UIImage *image = RSSWCallOriginal(path);
            image.prismAutoDotImageName = [self getImageNameFromPath:path];
            return image;
        })
                            );
        
        // Swizzle initWithContentsOfFile:
        RSSwizzleInstanceMethod(UIImage, @selector(initWithContentsOfFile:),
                                RSSWReturnType(UIImage *),
                                RSSWArguments(NSString *path),
                                RSSWReplacement({
            UIImage *image = RSSWCallOriginal(path);
            image.prismAutoDotImageName = [UIImage getImageNameFromPath:path];
            return image;
        }),
                                RSSwizzleModeAlways,
                                NULL);
    });
}

#pragma mark - private method
+ (NSString*)getImageNameFromPath:(NSString*)path {
    static NSString *separator = @"/";
    if ([path containsString:separator]) {
        NSArray<NSString*> *result = [path componentsSeparatedByString:separator];
        if (result.lastObject) {
            path = result.lastObject;
        }
    }
    return path;
}

#pragma mark - property
- (NSString *)prismAutoDotImageName {
    NSString *name = objc_getAssociatedObject(self, _cmd);
    return name;
}
- (void)setPrismAutoDotImageName:(NSString *)prismAutoDotImageName {
    objc_setAssociatedObject(self, @selector(prismAutoDotImageName), prismAutoDotImageName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)prismAutoDotImageUrl {
    NSString *name = objc_getAssociatedObject(self, _cmd);
    return name;
}
- (void)setPrismAutoDotImageUrl:(NSString *)prismAutoDotImageUrl {
    objc_setAssociatedObject(self, @selector(prismAutoDotImageUrl), prismAutoDotImageUrl, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
