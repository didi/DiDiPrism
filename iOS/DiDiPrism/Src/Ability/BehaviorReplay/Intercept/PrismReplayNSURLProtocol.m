//
//  PrismReplayNSURLProtocol.m
//  DiDiPrism
//
//  Created by hulk on 2020/4/1.
//

#import "PrismReplayNSURLProtocol.h"
#import "PrismBehaviorReplayManager.h"
#import "PrismBehaviorModel.h"
// Category
#import <DiDiPrism/NSDictionary+PrismExtends.h>

#define PRISM_REQUEST_HAS_INIT @"PrismRequestHasInit"
#define PRISM_REQUEST_MOCK_RESULT @"PrismRequestMockResult"
#define PRISM_REQUEST_INFOS @"PrismRequestInfos"

@interface PrismReplayNSURLProtocol() <NSURLSessionDelegate>
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation PrismReplayNSURLProtocol
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
    if ([PrismBehaviorReplayManager sharedManager].isInReplaying) {
        if([NSURLProtocol propertyForKey:PRISM_REQUEST_HAS_INIT inRequest:request]) {
            return NO;
        }
        NSArray<PrismBehaviorItemRequestInfoModel*> *requestInfos = [[PrismBehaviorReplayManager sharedManager] currentReplayRequestInfos];
        [NSURLProtocol setProperty:requestInfos forKey:PRISM_REQUEST_INFOS inRequest:request];
        NSString *urlFlag = [PrismBehaviorReplayManager sharedManager].urlFlagPickBlock ? [PrismBehaviorReplayManager sharedManager].urlFlagPickBlock(request) : nil;
        __block BOOL containURL = NO;
        [requestInfos enumerateObjectsUsingBlock:^(PrismBehaviorItemRequestInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.originUrl containsString:urlFlag]) {
                containURL = YES;
                *stop = YES;
            }
        }];
        return containURL;
    }
    
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    __block NSString *mockUrl = nil;
    __block NSDictionary *mockResult = nil;
    NSString *httpMethod = request.HTTPMethod;
    NSArray<PrismBehaviorItemRequestInfoModel*> *requestInfos = [NSURLProtocol propertyForKey:PRISM_REQUEST_INFOS inRequest:request];
    NSString *urlFlag = [NSString stringWithFormat:@"%@", request.URL.path];
    [requestInfos enumerateObjectsUsingBlock:^(PrismBehaviorItemRequestInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.originUrl containsString:urlFlag]) {
            /*
             关于真实数据源的说明：
                方式一、支持通过traceId获取真实数据源。
                方式二、也支持直接传入准备好的数据源。
             */
            if (obj.result) {
                // 方式二
                mockResult = obj.result;
            }
            else {
                // 方式一
                mockUrl = obj.mockUrl;
            }
            *stop = YES;
        }
    }];
    
    NSMutableURLRequest *mutableReqeust = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:mockUrl]];
    mutableReqeust.HTTPMethod = httpMethod;
    [NSURLProtocol setProperty:@(YES) forKey:PRISM_REQUEST_HAS_INIT inRequest:mutableReqeust];
    [NSURLProtocol setProperty:mockResult forKey:PRISM_REQUEST_MOCK_RESULT inRequest:mutableReqeust];
    request = [mutableReqeust copy];
    return request;
}

- (id)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id <NSURLProtocolClient>)client {
    return [super initWithRequest:request cachedResponse:cachedResponse client:client];
}

- (void)startLoading {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:mainQueue];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:self.request];
    [task resume];
}

- (void)stopLoading {
    [self.session invalidateAndCancel];
    self.session = nil;
}

#pragma mark - delegate
#pragma mark NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        NSDictionary *dataDictionary = [NSURLProtocol propertyForKey:PRISM_REQUEST_MOCK_RESULT inRequest:task.currentRequest];
        if (dataDictionary.allKeys.count) {
            NSError *error = nil;
            NSData *realData = [NSJSONSerialization dataWithJSONObject:dataDictionary
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:&error];
            if (!error && realData) {
                [self.client URLProtocol:self didLoadData:realData];
            }
        }

        [self.client URLProtocolDidFinishLoading:self];
    }
}


#pragma mark - setters

#pragma mark - getters

@end
