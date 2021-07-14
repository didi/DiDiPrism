//
//  PrismInterceptSystemEventAssist.m
//  DiDiPrism
//
//  Created by hulk on 2021/7/1.
//

#import "PrismInterceptSystemEventAssist.h"
// Dispatcher
#import "PrismEventDispatcher.h"

@implementation PrismInterceptSystemEventAssist
#pragma mark - public method
+ (void)prism_addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

#pragma mark - action
+ (void)didFinishLaunching:(NSNotification*)notification {
    // 支持端外打开逻辑
    if ([notification.userInfo.allKeys containsObject:UIApplicationLaunchOptionsURLKey]) {
        NSURL *openUrl = notification.userInfo[UIApplicationLaunchOptionsURLKey];
        if (openUrl.absoluteString.length) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"openUrl"] = openUrl.absoluteString;
            [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIApplicationLaunchByURL withSender:nil params:[params copy]];
        }
    }
}

+ (void)didBecomeActive:(NSNotification*)notification {
    [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIApplicationDidBecomeActive withSender:nil params:nil];
}

+ (void)willResignActive:(NSNotification*)notification {
    [[PrismEventDispatcher sharedInstance] dispatchEvent:PrismDispatchEventUIApplicationWillResignActive withSender:nil params:nil];
}
@end
