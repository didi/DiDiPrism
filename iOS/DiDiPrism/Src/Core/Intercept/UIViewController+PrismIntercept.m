//
//  UIViewController+PrismIntercept.m
//  DiDiPrism
//
//  Created by hulk on 2019/8/13.
//

#import "UIViewController+PrismIntercept.h"
// Dispatcher
#import "PrismEventDispatcher.h"
// Util
#import "PrismRuntimeUtil.h"

@implementation UIViewController (PrismIntercept)
#pragma mark - public method
+ (void)prism_swizzleMethodIMP {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(viewDidAppear:) swizzledSelector:@selector(prism_autoDot_viewDidAppear:)];
    });
}

#pragma mark - private method
- (void)prism_autoDot_viewDidAppear:(BOOL)animated {
    //原始逻辑
    [self prism_autoDot_viewDidAppear:animated];
    
    [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIViewControllerViewDidAppear withSender:self params:nil];
}
@end
