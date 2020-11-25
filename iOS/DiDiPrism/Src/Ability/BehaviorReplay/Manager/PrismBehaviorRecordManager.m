//
//  PrismBehaviorRecordManager.m
//  DiDiPrism
//
//  Created by hulk on 2019/7/3.
//

#import "PrismBehaviorRecordManager.h"
#import "PrismInstructionDefines.h"
#import "NSDictionary+PrismExtends.h"

@interface PrismBehaviorRecordManager()

@end

@implementation PrismBehaviorRecordManager
#pragma mark - life cycle
+ (instancetype)sharedInstance {
    static PrismBehaviorRecordManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PrismBehaviorRecordManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if ([self canHook]) {
            [self addNotifications];
        }
    }
    return self;
}

#pragma mark - public method
- (BOOL)canHook {
    return YES;
}

- (BOOL)canUpload {
    return YES;
}

- (BOOL)canH5Upload {
    return YES;
}

- (void)addInstruction:(NSString *)instruction {
    [self addInstruction:instruction withEventParams:nil];
}

- (void)addInstruction:(NSString*)instruction withEventParams:(NSDictionary*)eventParams {
    if (!instruction.length) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"prism_new_instruction_notification" object:nil userInfo:@{@"instruction":instruction, @"params":eventParams.allKeys.count ? eventParams : @{}}];
}

- (void)addRequestInfoWithUrl:(NSString *)url traceId:(NSString *)traceId {
    if (!url.length || !traceId.length) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"prism_new_request_notification" object:nil userInfo:@{@"url":url, @"traceId":traceId}];
    });
}

#pragma mark - delegate
#pragma mark WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([self canH5Upload] == NO) {
        return;
    }
    if ([message.name isEqualToString:@"prism_record_instruct"]) {
        NSString *instruct = [NSString stringWithFormat:@"%@%@%@%@", kBeginOfH5Flag, [message.body prism_stringForKey:@"instruct"], kBeginOfViewRepresentativeContentFlag, [message.body prism_stringForKey:@"content"]];
        [self addInstruction:instruct];
    }
}

#pragma mark - action
- (void)didFinishLaunching:(NSNotification*)notification {
    if ([self canHook] == NO) {
        return;
    }
    // 支持端外打开逻辑
    if ([notification.userInfo.allKeys containsObject:UIApplicationLaunchOptionsURLKey]) {
        NSURL *openUrl = notification.userInfo[UIApplicationLaunchOptionsURLKey];
        if (openUrl.absoluteString.length) {
            NSString *instruction = [NSString stringWithFormat:@"%@%@%@", kUIApplicationOpenURL, kBeginOfViewRepresentativeContentFlag, openUrl.absoluteString];
            [self addInstruction:instruction];
        }
    }
}

- (void)didBecomeActive:(NSNotification*)notification {
    if ([self canUpload]) {
        [self addInstruction:kUIApplicationBecomeActive];
    }
}

- (void)willResignActive:(NSNotification*)notification {
    if ([self canUpload]) {
        [self addInstruction:kUIApplicationResignActive];
    }
}

#pragma mark - private method
- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

#pragma mark - setters

#pragma mark - getters

@end
