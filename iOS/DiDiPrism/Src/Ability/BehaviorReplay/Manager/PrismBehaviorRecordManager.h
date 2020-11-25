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
+ (instancetype)sharedInstance;
@property (nonatomic, assign) BOOL isInReplaying;

/*
 是否可以Hook。
 */
- (BOOL)canHook;
/*
 是否可以上报指令。
 */
- (BOOL)canUpload;
/*
是否可以上报H5页面指令。
*/
- (BOOL)canH5Upload;

- (void)addInstruction:(NSString*)instruction;
- (void)addInstruction:(NSString*)instruction withEventParams:(NSDictionary*)eventParams;
- (void)addRequestInfoWithUrl:(NSString*)url traceId:(NSString*)traceId;
@end

NS_ASSUME_NONNULL_END
