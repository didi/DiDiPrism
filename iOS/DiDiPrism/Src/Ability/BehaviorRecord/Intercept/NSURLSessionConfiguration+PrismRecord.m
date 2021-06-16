//
//  NSURLSessionConfiguration+PrismRecord.m
//  DiDiPrism
//
//  Created by hulk on 2020/4/1.
//

#import "NSURLSessionConfiguration+PrismRecord.h"
#import "PrismRecordNSURLProtocol.h"
// Util
#import "PrismRuntimeUtil.h"

@implementation NSURLSessionConfiguration (PrismRecord)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [PrismRuntimeUtil hookClass:object_getClass(self) originalSelector:@selector(defaultSessionConfiguration) swizzledSelector:@selector(prism_autoDot_defaultSessionConfiguration) isClassMethod:YES];
        [PrismRuntimeUtil hookClass:object_getClass(self) originalSelector:@selector(ephemeralSessionConfiguration) swizzledSelector:@selector(prism_autoDot_ephemeralSessionConfiguration) isClassMethod:YES];
    });
}

+ (NSURLSessionConfiguration *)prism_autoDot_defaultSessionConfiguration{
    NSURLSessionConfiguration *configuration = [self prism_autoDot_defaultSessionConfiguration];
    NSMutableArray * protocolClasses = [NSMutableArray arrayWithArray:configuration.protocolClasses];
    [protocolClasses insertObject:[PrismRecordNSURLProtocol class] atIndex:0];
    configuration.protocolClasses = [protocolClasses copy];
    return configuration;
}

+ (NSURLSessionConfiguration *)prism_autoDot_ephemeralSessionConfiguration{
    NSURLSessionConfiguration *configuration = [self prism_autoDot_ephemeralSessionConfiguration];
    NSMutableArray * protocolClasses = [NSMutableArray arrayWithArray:configuration.protocolClasses];
    [protocolClasses insertObject:[PrismRecordNSURLProtocol class] atIndex:0];
    configuration.protocolClasses = [protocolClasses copy];
    return configuration;
}
@end
