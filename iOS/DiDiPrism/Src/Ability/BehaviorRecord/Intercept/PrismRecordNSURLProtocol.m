//
//  PrismRecordNSURLProtocol.m
//  DiDiPrism
//
//  Created by hulk on 2020/4/1.
//

#import "PrismRecordNSURLProtocol.h"
#import "PrismBehaviorRecordManager.h"

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
    if ([[PrismBehaviorRecordManager sharedManager] canUpload] == NO) {
        return NO;
    }
    if (![request.URL.scheme isEqualToString:@"http"]
        && ![request.URL.scheme isEqualToString:@"https"]) {
        return NO;
    }
    NSString *urlFlag = [PrismBehaviorRecordManager sharedManager].urlFlagPickBlock ? [PrismBehaviorRecordManager sharedManager].urlFlagPickBlock(request) : nil;
    NSString *traceId = [PrismBehaviorRecordManager sharedManager].traceIdPickBlock ? [PrismBehaviorRecordManager sharedManager].traceIdPickBlock(request) : nil;
    [[PrismBehaviorRecordManager sharedManager] addRequestInfoWithUrl:urlFlag traceId:traceId];
    
    return NO;
}

#pragma mark - delegate

#pragma mark - setters

#pragma mark - getters

@end
