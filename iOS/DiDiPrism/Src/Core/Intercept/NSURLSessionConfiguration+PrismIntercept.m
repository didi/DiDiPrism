//
//  NSURLSessionConfiguration+PrismIntercept.m
//  DiDiPrism
//
//  Created by hulk on 2020/4/1.
//

#import "NSURLSessionConfiguration+PrismIntercept.h"
// Util
#import "PrismRuntimeUtil.h"

@implementation NSURLSessionConfiguration (PrismIntercept)
+ (void)prism_swizzleMethodIMP {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [PrismRuntimeUtil hookClass:object_getClass(self) originalSelector:@selector(defaultSessionConfiguration) swizzledSelector:@selector(prism_autoDot_defaultSessionConfiguration) isClassMethod:YES];
        [PrismRuntimeUtil hookClass:object_getClass(self) originalSelector:@selector(ephemeralSessionConfiguration) swizzledSelector:@selector(prism_autoDot_ephemeralSessionConfiguration) isClassMethod:YES];
    });
}

+ (NSURLSessionConfiguration *)prism_autoDot_defaultSessionConfiguration {
    NSURLSessionConfiguration *configuration = [self prism_autoDot_defaultSessionConfiguration];
    NSMutableArray * protocolClasses = [NSMutableArray arrayWithArray:configuration.protocolClasses];
    Class protocolClass = NSClassFromString(@"PrismRecordNSURLProtocol");
    if (protocolClass) {
        [protocolClasses insertObject:protocolClass atIndex:0];
    }
    configuration.protocolClasses = [protocolClasses copy];
    return configuration;
}

+ (NSURLSessionConfiguration *)prism_autoDot_ephemeralSessionConfiguration {
    NSURLSessionConfiguration *configuration = [self prism_autoDot_ephemeralSessionConfiguration];
    NSMutableArray * protocolClasses = [NSMutableArray arrayWithArray:configuration.protocolClasses];
    Class protocolClass = NSClassFromString(@"PrismRecordNSURLProtocol");
    if (protocolClass) {
        [protocolClasses insertObject:protocolClass atIndex:0];
    }
    configuration.protocolClasses = [protocolClasses copy];
    return configuration;
}
@end
