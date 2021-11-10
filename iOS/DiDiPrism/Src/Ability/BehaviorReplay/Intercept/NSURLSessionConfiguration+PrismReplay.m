//
//  NSURLSessionConfiguration+PrismReplay.m
//  DiDiPrism
//
//  Created by hulk on 2020/4/1.
//

#import "NSURLSessionConfiguration+PrismReplay.h"
#import "PrismReplayNSURLProtocol.h"
// Util
#import <DiDiPrism/PrismRuntimeUtil.h>

@implementation NSURLSessionConfiguration (PrismReplay)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [PrismRuntimeUtil hookClass:object_getClass(self) originalSelector:@selector(defaultSessionConfiguration) swizzledSelector:@selector(autoReplay_defaultSessionConfiguration) isClassMethod:YES];
        [PrismRuntimeUtil hookClass:object_getClass(self) originalSelector:@selector(ephemeralSessionConfiguration) swizzledSelector:@selector(autoReplay_ephemeralSessionConfiguration) isClassMethod:YES];
    });
}

+ (NSURLSessionConfiguration *)autoReplay_defaultSessionConfiguration{
    NSURLSessionConfiguration *configuration = [self autoReplay_defaultSessionConfiguration];
    NSMutableArray * protocolClasses = [NSMutableArray arrayWithArray:configuration.protocolClasses];
    [protocolClasses insertObject:[PrismReplayNSURLProtocol class] atIndex:0];
    configuration.protocolClasses = [protocolClasses copy];
    return configuration;
}

+ (NSURLSessionConfiguration *)autoReplay_ephemeralSessionConfiguration{
    NSURLSessionConfiguration *configuration = [self autoReplay_ephemeralSessionConfiguration];
    NSMutableArray * protocolClasses = [NSMutableArray arrayWithArray:configuration.protocolClasses];
    [protocolClasses insertObject:[PrismReplayNSURLProtocol class] atIndex:0];
    configuration.protocolClasses = [protocolClasses copy];
    return configuration;
}
@end
