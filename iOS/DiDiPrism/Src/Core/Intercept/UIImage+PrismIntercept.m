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
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [PrismRuntimeUtil hookClass:object_getClass(self) originalSelector:@selector(imageNamed:) swizzledSelector:@selector(autoDot_imageNamed:) isClassMethod:YES];
        #if __has_include(<UIKit/UITraitCollection.h>)
        [PrismRuntimeUtil hookClass:object_getClass(self) originalSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:) swizzledSelector:@selector(autoDot_imageNamed:inBundle:compatibleWithTraitCollection:) isClassMethod:YES];
        #endif
        [PrismRuntimeUtil hookClass:object_getClass(self) originalSelector:@selector(imageWithContentsOfFile:) swizzledSelector:@selector(autoDot_imageWithContentsOfFile:) isClassMethod:YES];
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(initWithContentsOfFile:) swizzledSelector:@selector(autoDot_initWithContentsOfFile:)];
    });
}

+ (UIImage *)autoDot_imageNamed:(NSString *)name {
    UIImage *image = [self autoDot_imageNamed:name];
    
    image.autoDotImageName = [self getImageNameFromPath:name];
    
    return image;
}

+ (UIImage *)autoDot_imageNamed:(NSString *)name inBundle:(NSBundle *)bundle compatibleWithTraitCollection:(UITraitCollection *)traitCollection {
    UIImage *image = [self autoDot_imageNamed:name inBundle:bundle compatibleWithTraitCollection:traitCollection];
    
    image.autoDotImageName = [self getImageNameFromPath:name];
    
    return image;
}

+ (UIImage *)autoDot_imageWithContentsOfFile:(NSString *)path {
    UIImage *image = [self autoDot_imageWithContentsOfFile:path];
    
    image.autoDotImageName = [self getImageNameFromPath:path];
    
    return image;
}

- (instancetype)autoDot_initWithContentsOfFile:(NSString *)path {
    UIImage *image = [self autoDot_initWithContentsOfFile:path];
    
    image.autoDotImageName = [UIImage getImageNameFromPath:path];
    
    return image;
}

#pragma mark - property
- (NSString *)autoDotImageName {
    NSString *name = objc_getAssociatedObject(self, _cmd);
    return name;
}
- (void)setAutoDotImageName:(NSString *)autoDotImageName {
    objc_setAssociatedObject(self, @selector(autoDotImageName), autoDotImageName, OBJC_ASSOCIATION_COPY_NONATOMIC);
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

@end
