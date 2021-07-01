//
//  UIImage+PrismIntercept.m
//  DiDiPrism
//
//  Created by hulk on 2019/6/27.
//

#import "UIImage+PrismIntercept.h"
// Util
#import "PrismRuntimeUtil.h"

@implementation UIImage (PrismIntercept)
#pragma mark - public method
+ (void)prism_swizzleMethodIMP {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [PrismRuntimeUtil hookClass:object_getClass(self) originalSelector:@selector(imageNamed:) swizzledSelector:@selector(prism_autoDot_imageNamed:) isClassMethod:YES];
        #if __has_include(<UIKit/UITraitCollection.h>)
        [PrismRuntimeUtil hookClass:object_getClass(self) originalSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:) swizzledSelector:@selector(prism_autoDot_imageNamed:inBundle:compatibleWithTraitCollection:) isClassMethod:YES];
        #endif
        [PrismRuntimeUtil hookClass:object_getClass(self) originalSelector:@selector(imageWithContentsOfFile:) swizzledSelector:@selector(prism_autoDot_imageWithContentsOfFile:) isClassMethod:YES];
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(initWithContentsOfFile:) swizzledSelector:@selector(prism_autoDot_initWithContentsOfFile:)];
    });
}

#pragma mark - private method
+ (UIImage *)prism_autoDot_imageNamed:(NSString *)name {
    UIImage *image = [self prism_autoDot_imageNamed:name];
    
    image.prismAutoDotImageName = [self getImageNameFromPath:name];
    
    return image;
}

+ (UIImage *)prism_autoDot_imageNamed:(NSString *)name inBundle:(NSBundle *)bundle compatibleWithTraitCollection:(UITraitCollection *)traitCollection {
    UIImage *image = [self prism_autoDot_imageNamed:name inBundle:bundle compatibleWithTraitCollection:traitCollection];
    
    image.prismAutoDotImageName = [self getImageNameFromPath:name];
    
    return image;
}

+ (UIImage *)prism_autoDot_imageWithContentsOfFile:(NSString *)path {
    UIImage *image = [self prism_autoDot_imageWithContentsOfFile:path];
    
    image.prismAutoDotImageName = [self getImageNameFromPath:path];
    
    return image;
}

- (instancetype)prism_autoDot_initWithContentsOfFile:(NSString *)path {
    UIImage *image = [self prism_autoDot_initWithContentsOfFile:path];
    
    image.prismAutoDotImageName = [UIImage getImageNameFromPath:path];
    
    return image;
}

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

@end
