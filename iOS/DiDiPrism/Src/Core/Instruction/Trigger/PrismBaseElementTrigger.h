//
//  PrismBaseElementTrigger.h
//  DiDiPrism
//
//  Created by hulk on 2022/3/17.
//

#import <Foundation/Foundation.h>
#import "PrismInstructionFormatter.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrismBaseElementTrigger : NSObject
+ (instancetype)elementTriggerWithFormatter:(PrismInstructionFormatter*)formatter;

@property (nonatomic, assign) BOOL needExecute; //是否真正触发。

- (void)triggerWithElement:(NSObject*)element withNewValue:(id)newValue withDelay:(NSTimeInterval)delaySeconds;
- (void)highlightTheElement:(UIView*)element withNewColor:(UIColor*)color withDelay:(NSTimeInterval)delaySeconds withCompletion:(void(^)(void))block;
@end

NS_ASSUME_NONNULL_END
