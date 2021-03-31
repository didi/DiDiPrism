//
//  PrismImageUtil.m
//  DiDiPrism
//
//  Created by hulk on 2021/3/31.
//

#import "PrismImageUtil.h"

@implementation PrismImageUtil
+ (nullable UIImage *)imageNamed:(NSString *)name {
    if (!name.length) {
        return nil;
    }
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle.resourcePath stringByAppendingPathComponent:@"/DiDiPrism.bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    return [UIImage imageNamed:name inBundle:resourceBundle compatibleWithTraitCollection:nil];
}

@end
