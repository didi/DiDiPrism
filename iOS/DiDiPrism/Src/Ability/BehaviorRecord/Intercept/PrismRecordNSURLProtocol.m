//
//  PrismRecordNSURLProtocol.m
//  DiDiPrism
//
//  Created by hulk on 2020/4/1.
//

#import "PrismRecordNSURLProtocol.h"
#import <objc/runtime.h>
#import "PrismBehaviorRecordManager.h"
// Category
#import <DiDiPrism/NSDictionary+PrismExtends.h>

@interface PrismRecordNSURLProtocol() <NSURLSessionDelegate>
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation PrismRecordNSURLProtocol
#pragma mark - life cycle

#pragma mark - override method
+ (BOOL)canInitWithTask:(NSURLSessionTask *)task {
    NSURLRequest *request = task.currentRequest;
    return request == nil ? NO : [self canInitWithRequest:request];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if (![request.URL.scheme isEqualToString:@"http"]
        && ![request.URL.scheme isEqualToString:@"https"]) {
        return NO;
    }
    NSString *urlFlag = self.urlFlagPickBlock ? self.urlFlagPickBlock(request) : nil;
    NSString *traceId = self.traceIdPickBlock ? self.traceIdPickBlock(request) : nil;
    [[PrismBehaviorRecordManager sharedManager] addRequestInfoWithUrl:urlFlag traceId:traceId];
    
    return NO;
}

#pragma mark - delegate

#pragma mark - setters
+ (void)setUrlFlagPickBlock:(NSString * _Nonnull (^)(NSURLRequest * _Nonnull))urlFlagPickBlock {
    objc_setAssociatedObject(self, @selector(urlFlagPickBlock), urlFlagPickBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)setTraceIdPickBlock:(NSString * _Nonnull (^)(NSURLRequest * _Nonnull))traceIdPickBlock {
    objc_setAssociatedObject(self, @selector(traceIdPickBlock), traceIdPickBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getters
+ (NSString * _Nonnull (^)(NSURLRequest * _Nonnull))urlFlagPickBlock {
    id result = objc_getAssociatedObject(self, _cmd);
    if (!result) {
        result = ^(NSURLRequest* request) {
            return [NSString stringWithFormat:@"%@%@", request.URL.host, request.URL.path];
        };
        objc_setAssociatedObject(self, @selector(urlFlagPickBlock), result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return result;
}

+ (NSString * _Nonnull (^)(NSURLRequest * _Nonnull))traceIdPickBlock {
    id result = objc_getAssociatedObject(self, _cmd);
    if (!result) {
        result = ^(NSURLRequest* request) {
            NSDictionary *header = request.allHTTPHeaderFields;
            NSString *traceIdKey = @"traceid";
            return [header prism_stringForKey:traceIdKey];
        };
        objc_setAssociatedObject(self, @selector(traceIdPickBlock), result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return result;
}

@end
