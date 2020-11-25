//
//  PrismInterceptNSURLProtocol.m
//  DiDiPrism
//
//  Created by hulk on 2020/4/1.
//

#import "PrismInterceptNSURLProtocol.h"
#import "PrismBehaviorRecordManager.h"
// Category
#import "NSDictionary+PrismExtends.h"

@interface PrismInterceptNSURLProtocol()

@end

@implementation PrismInterceptNSURLProtocol
#pragma mark - life cycle

#pragma mark - public method

#pragma mark - private method

#pragma mark - override method
+ (BOOL)canInitWithTask:(NSURLSessionTask *)task {
    NSURLRequest *request = task.currentRequest;
    return request == nil ? NO : [self canInitWithRequest:request];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if ([[PrismBehaviorRecordManager sharedInstance] canUpload] == NO) {
        return NO;
    }
    if (![request.URL.scheme isEqualToString:@"http"]
        && ![request.URL.scheme isEqualToString:@"https"]) {
        return NO;
    }
    NSDictionary *header = request.allHTTPHeaderFields;
    NSString *traceIdKey = @"配置承载trace id的key";
    if ([header.allKeys containsObject:traceIdKey]) {
        NSString *urlFlag = [NSString stringWithFormat:@"%@%@", request.URL.host, request.URL.path];
        NSString *traceId = [header prism_stringForKey:traceIdKey];
        [[PrismBehaviorRecordManager sharedInstance] addRequestInfoWithUrl:urlFlag traceId:traceId];
    }
    
    return NO;
}

#pragma mark - setters

#pragma mark - getters

@end
