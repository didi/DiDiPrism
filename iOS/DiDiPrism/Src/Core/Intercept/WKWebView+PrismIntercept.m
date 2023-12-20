//
//  WKWebView+PrismIntercept.m
//  DiDiPrism
//
//  Created by hulk on 2021/1/5.
//

#import "WKWebView+PrismIntercept.h"
#import <objc/runtime.h>
#import <RSSwizzle/RSSwizzle.h>
// Dispatcher
#import "PrismEventDispatcher.h"

@implementation WKWebView (PrismIntercept)
#pragma mark - public method
+ (void)prism_swizzleMethodIMP {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Swizzle initWithFrame:configuration:
        RSSwizzleInstanceMethod(WKWebView, @selector(initWithFrame:configuration:),
                                RSSWReturnType(WKWebView*),
                                RSSWArguments(CGRect frame, WKWebViewConfiguration *configuration),
                                RSSWReplacement({
            WKWebView *webView = RSSWCallOriginal(frame, configuration);
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            if (configuration) {
                params[@"configuration"] = configuration;
            }
            [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventWKWebViewInitWithFrame withSender:self params:[params copy]];
            
            return webView;
        }),
                                RSSwizzleModeAlways,
                                NULL);
    });
}

- (void)prism_autoDot_addCustomScript:(NSString *)customScript withConfiguration:(WKWebViewConfiguration *)configuration {
    if(!customScript.length) return;
    
    NSArray *scripts = [configuration.userContentController userScripts];
    for(WKUserScript *script in scripts){
        if([script.source isEqualToString:customScript])
            return;
    }
    
    WKUserScript *script = [[WKUserScript alloc] initWithSource:customScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [configuration.userContentController addUserScript:script];
}

#pragma mark - private method

@end
