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
#import "UILongPressGestureRecognizer+PrismIntercept.h"
#import "UITapGestureRecognizer+PrismIntercept.h"
#import "UIView+PrismIntercept.h"
#import "UIViewController+PrismIntercept.h"
#import "WKWebView+PrismIntercept.h"
#import "NSURLSessionConfiguration+PrismIntercept.h"
#import "UIScreenEdgePanGestureRecognizer+PrismIntercept.h"

@implementation PrismEngine
#pragma mark public method
+ (void)startEngineWithEventCategorys:(PrismEventCategory)eventCategorys {
    [UIImage prism_swizzleMethodIMP];
    
    if (eventCategorys & PrismEventCategoryTouch) {
        [UIControl prism_swizzleMethodIMP];
        [UITapGestureRecognizer prism_swizzleMethodIMP];
        [UILongPressGestureRecognizer prism_swizzleMethodIMP];
        [UIView prism_swizzleMethodIMP];
        [WKWebView prism_swizzleMethodIMP];
    }
    
    if (eventCategorys & PrismEventCategorySlip) {
        [UIScreenEdgePanGestureRecognizer setPrismHookEnable:YES];
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
}
@end
