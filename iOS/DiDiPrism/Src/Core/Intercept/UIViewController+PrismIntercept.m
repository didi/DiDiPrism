//
//  UIViewController+PrismIntercept.m
//  DiDiPrism
//
//  Created by hulk on 2019/8/13.
//

#import "UIViewController+PrismIntercept.h"
#import <objc/runtime.h>
#import <RSSwizzle/RSSwizzle.h>
// Dispatcher
#import "PrismEventDispatcher.h"

@implementation UIViewController (PrismIntercept)
#pragma mark - public method
+ (void)prism_swizzleMethodIMP {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Swizzle viewDidAppear:
        RSSwizzleInstanceMethod(UIViewController, @selector(viewDidAppear:),
                                RSSWReturnType(void),
                                RSSWArguments(BOOL animated),
                                RSSWReplacement({
            RSSWCallOriginal(animated);
            
            [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIViewControllerViewDidAppear withSender:self params:nil];
        }),
                                RSSwizzleModeAlways,
                                NULL);
    });
}

#pragma mark - private method

@end
