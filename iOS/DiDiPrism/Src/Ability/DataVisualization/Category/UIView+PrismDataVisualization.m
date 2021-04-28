//
//  UIView+PrismDataVisualization.m
//  DiDiPrism
//
//  Created by hulk on 2021/3/29.
//

#import "UIView+PrismDataVisualization.h"
#import <objc/runtime.h>

@implementation UIView (PrismDataVisualization)
#pragma mark - property
- (PrismElementRelatedInfos *)relatedInfos {
    PrismElementRelatedInfos *relatedInfos = objc_getAssociatedObject(self, _cmd);
//    if (!relatedInfos && [self valueForKey:@"wx_component"]) {
//        relatedInfos = [[self valueForKey:@"wx_component"] valueForKey:@"relatedInfos"];
//        objc_setAssociatedObject(self, @selector(relatedInfos), relatedInfos, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
    if (!relatedInfos) {
        relatedInfos = [[PrismElementRelatedInfos alloc] init];
        objc_setAssociatedObject(self, @selector(relatedInfos), relatedInfos, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return relatedInfos;
}
- (void)setRelatedInfos:(PrismElementRelatedInfos *)relatedInfos {
    objc_setAssociatedObject(self, @selector(relatedInfos), relatedInfos, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
