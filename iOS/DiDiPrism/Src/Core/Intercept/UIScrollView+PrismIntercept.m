//
//  UIScrollView+PrismIntercept.m
//  DiDiPrism
//
//  Created by hulk on 2021/8/19.
//

#import "UIScrollView+PrismIntercept.h"
// Dispatcher
#import "PrismEventDispatcher.h"
// Util
#import "PrismRuntimeUtil.h"

@implementation UIScrollView (PrismIntercept)
#pragma mark - public method
+ (void)prism_swizzleMethodIMP {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(setContentOffset:) swizzledSelector:@selector(prism_autoDot_setContentOffset:)];
    });
}

#pragma mark - private method
- (void)prism_autoDot_setContentOffset:(CGPoint)contentOffset {
    //原始逻辑
    [self prism_autoDot_setContentOffset:contentOffset];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"contentOffset"] = [NSValue valueWithCGPoint:contentOffset];
    [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIScrollViewSetContentOffset withSender:self params:[params copy]];
}
@end
