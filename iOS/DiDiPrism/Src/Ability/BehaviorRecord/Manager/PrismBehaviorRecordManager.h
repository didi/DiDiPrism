//
//  PrismBehaviorRecordManager.h
//  DiDiPrism
//
//  Created by hulk on 2019/7/3.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrismBehaviorRecordManager : NSObject <WKScriptMessageHandler>
+ (instancetype)sharedManager;

/*
 初始化
 */
- (void)install;
- (void)uninstall;

- (void)addInstruction:(NSString*)instruction;
- (void)addInstruction:(NSString*)instruction withEventParams:(NSDictionary*)eventParams;
- (void)addRequestInfoWithUrl:(NSString*)url traceId:(NSString*)traceId;
@end

NS_ASSUME_NONNULL_END
