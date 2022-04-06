//
//  PrismInstructionInputUtil.h
//  DiDiPrism
//
//  Created by hulk on 2022/4/2.
//

#import <Foundation/Foundation.h>
#import "PrismInstructionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrismInstructionInputUtil : NSObject
+ (BOOL)isSystemKeyboardTouchEventWithModel:(PrismInstructionModel*)model;
+ (BOOL)isSystemKeyboardOfViewController:(UIViewController*)viewController;
@end

NS_ASSUME_NONNULL_END
