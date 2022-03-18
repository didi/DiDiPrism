//
//  PrismTapGestureInstructionGenerator.h
//  DiDiPrism
//
//  Created by hulk on 2020/9/24.
//

#import <Foundation/Foundation.h>
#import "PrismInstructionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrismTapGestureInstructionGenerator : NSObject

+ (PrismInstructionModel*)getInstructionModelOfTapGesture:(UITapGestureRecognizer*)tapGesture;
+ (NSString*)getFunctionNameOfTapGesture:(UITapGestureRecognizer*)tapGesture;
@end

NS_ASSUME_NONNULL_END
