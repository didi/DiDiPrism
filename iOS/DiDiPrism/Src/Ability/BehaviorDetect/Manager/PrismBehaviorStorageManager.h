//
//  PrismBehaviorStorageManager.h
//  DiDiPrism
//
//  Created by hulk on 2020/10/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define PrismBehaviorInstructionKey @"instruction"
#define PrismBehaviorParamsKey @"params"
#define PrismBehaviorDataMaxDay 30

@interface PrismBehaviorStorageManager : NSObject
+ (instancetype)sharedInstance;

#if OS_OBJECT_USE_OBJC
@property (nonatomic, strong) dispatch_queue_t workQueue;
#else
@property (nonatomic, assign) dispatch_queue_t workQueue;
#endif

- (void)addInstruction:(NSString*)instruction withParams:(NSDictionary*)params;
- (NSArray<NSDictionary*>*)readFileOfDays:(NSInteger)days;
@end

NS_ASSUME_NONNULL_END
