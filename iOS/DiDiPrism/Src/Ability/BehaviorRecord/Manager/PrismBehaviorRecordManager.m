//
//  PrismBehaviorRecordManager.m
//  DiDiPrism
//
//  Created by hulk on 2019/7/3.
//

#import "PrismBehaviorRecordManager.h"
#import <DiDiPrism/PrismEventDispatcher.h>
// Instruction
#import <DiDiPrism/PrismInstructionDefines.h>
// Category
#import <DiDiPrism/NSDictionary+PrismExtends.h>

@interface PrismBehaviorRecordManager()

@end

@implementation PrismBehaviorRecordManager
#pragma mark - life cycle
+ (instancetype)sharedManager {
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
        
    }
    return self;
}

#pragma mark - public method
- (void)install {
    [[PrismEventDispatcher sharedInstance] registerListener:(id<PrismDispatchListenerProtocol>)self];
}

- (void)uninstall {
    [[PrismEventDispatcher sharedInstance] unregisterListener:(id<PrismDispatchListenerProtocol>)self];
    
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
    if ([message.name isEqualToString:@"prism_record_instruct"]) {
        NSString *instruct = [NSString stringWithFormat:@"%@%@%@%@", kBeginOfH5Flag, [message.body prism_stringForKey:@"instruct"], kBeginOfViewRepresentativeContentFlag, [message.body prism_stringForKey:@"content"]];
        [self addInstruction:instruct];
    }
}

#pragma mark - action

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
