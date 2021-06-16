//
//  WKWebView+PrismIntercept.m
//  DiDiPrism
//
//  Created by hulk on 2021/1/5.
//

#import "WKWebView+PrismIntercept.h"
// Dispatcher
#import "PrismEventDispatcher.h"
// Util
#import "PrismRuntimeUtil.h"

@implementation WKWebView (PrismIntercept)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(initWithFrame:configuration:) swizzledSelector:@selector(prism_autoDot_initWithFrame:configuration:)];
    });
}

- (instancetype)prism_autoDot_initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    WKWebView *webView = [self prism_autoDot_initWithFrame:frame configuration:configuration];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (configuration) {
        params[@"configuration"] = configuration;
    }
    [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventWKWebViewInitWithFrame withSender:self params:[params copy]];
    
    return webView;
}

- (void)prism_autoDot_addCustomScript:(NSString *)customScript withConfiguration:(WKWebViewConfiguration *)configuration {
    if(!customScript.length) return;
    
    NSArray *scripts = [configuration.userContentController userScripts];
    for(WKUserScript *script in scripts){
        if([script.source isEqualToString:customScript])
            return;
    }
    
    WKUserScript *script = [[WKUserScript alloc] initWithSource:customScript injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    [configuration.userContentController addUserScript:script];
}
@end
