//
//  PrismEngine.m
//  DiDiPrism
//
//  Created by hulk on 2021/6/30.
//

#import "PrismEngine.h"
#import "PrismInterceptSystemEventAssist.h"
// Category
#import "UIControl+PrismIntercept.h"
#import "UIImage+PrismIntercept.h"
#import "SDImageCache+PrismIntercept.h"
#import "UILongPressGestureRecognizer+PrismIntercept.h"
#import "UITapGestureRecognizer+PrismIntercept.h"
#import "UIView+PrismIntercept.h"
#import "UIViewController+PrismIntercept.h"
#import "WKWebView+PrismIntercept.h"
#import "NSURLSessionConfiguration+PrismIntercept.h"
#import "UIScreenEdgePanGestureRecognizer+PrismIntercept.h"
#import "UIScrollView+PrismIntercept.h"
#import "UITextField+PrismIntercept.h"

@implementation PrismEngine
#pragma mark public method
+ (void)startEngineWithEventCategorys:(PrismEventCategory)eventCategorys {
    [UIImage prism_swizzleMethodIMP];
#if __has_include(<SDWebImage/SDImageCache.h>)
    [SDImageCache prism_swizzleMethodIMP];
#endif
    
    if (eventCategorys & PrismEventCategoryTouch) {
        [UIControl prism_swizzleMethodIMP];
        [UITapGestureRecognizer prism_swizzleMethodIMP];
        [UILongPressGestureRecognizer prism_swizzleMethodIMP];
        [UIView prism_swizzleMethodIMP];
        [WKWebView prism_swizzleMethodIMP];
    }
    
    if (eventCategorys & PrismEventCategorySlip) {
        [UIScreenEdgePanGestureRecognizer setPrismHookEnable:YES];
        [UIScrollView prism_swizzleMethodIMP];
    }
    
    if (eventCategorys & PrismEventCategoryPageSwitch) {
        [UIViewController prism_swizzleMethodIMP];
    }
    
    if (eventCategorys & PrismEventCategoryNetwork) {
        [NSURLSessionConfiguration prism_swizzleMethodIMP];
    }
    
    if (eventCategorys & PrismEventCategorySystem) {
        [PrismInterceptSystemEventAssist prism_addObserver];
    }
    
    if (eventCategorys & PrismEventCategoryInput) {
        [UITextField prism_swizzleMethodIMP];
    }
}
@end
