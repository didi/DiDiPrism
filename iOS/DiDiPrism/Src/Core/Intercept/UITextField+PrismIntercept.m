//
//  UITextField+PrismIntercept.m
//  DiDiPrism
//
//  Created by hulk on 2022/4/2.
//

#import "UITextField+PrismIntercept.h"
#import <objc/runtime.h>
#import <RSSwizzle/RSSwizzle.h>
// Dispatcher
#import "PrismEventDispatcher.h"

@implementation UITextField (PrismIntercept)
#pragma mark - public method
+ (void)prism_swizzleMethodIMP {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Swizzle becomeFirstResponder
        RSSwizzleInstanceMethod(UITextField, @selector(becomeFirstResponder),
                                RSSWReturnType(BOOL),
                                RSSWArguments(),
                                RSSWReplacement({
            SEL swizzleSelector = NSSelectorFromString(@"prism_becomeFirstResponder");
            Method swizzleMethod = class_getInstanceMethod([UITextField class], swizzleSelector);
            IMP swizzleMethodImp =  method_getImplementation(swizzleMethod);
            void (*functionPointer)(id, SEL) = (void (*)(id, SEL))swizzleMethodImp;
            functionPointer(self, _cmd);
            return RSSWCallOriginal();
        }),
                                RSSwizzleModeAlways,
                                NULL);
        
        // Swizzle resignFirstResponder
        RSSwizzleInstanceMethod(UITextField, @selector(resignFirstResponder),
                                RSSWReturnType(BOOL),
                                RSSWArguments(),
                                RSSWReplacement({
            SEL swizzleSelector = NSSelectorFromString(@"prism_resignFirstResponder");
            Method swizzleMethod = class_getInstanceMethod([UITextField class], swizzleSelector);
            IMP swizzleMethodImp =  method_getImplementation(swizzleMethod);
            void (*functionPointer)(id, SEL) = (void (*)(id, SEL))swizzleMethodImp;
            functionPointer(self, _cmd);
            return RSSWCallOriginal();
        }),
                                RSSwizzleModeAlways,
                                NULL);
    });
}

#pragma mark - private method
- (void)prism_becomeFirstResponder {
    [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUITextFieldBecomeFirstResponder withSender:self params:nil];
}

- (void)prism_resignFirstResponder {
    [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUITextFieldResignFirstResponder withSender:self params:nil];
}



#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
