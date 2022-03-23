//
//  PrismLongPressGestureInstructionGenerator.h
//  DiDiPrism
//
//  Created by hulk on 2021/6/25.
//

#import <Foundation/Foundation.h>
#import "PrismInstructionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrismLongPressGestureInstructionGenerator : NSObject
+ (PrismInstructionModel *)getInstructionModelOfLongPressGesture:(UILongPressGestureRecognizer *)longPressGesture;
+ (NSString*)getFunctionNameOfLongPressGesture:(UILongPressGestureRecognizer*)longPressGesture;
@end

NS_ASSUME_NONNULL_END
