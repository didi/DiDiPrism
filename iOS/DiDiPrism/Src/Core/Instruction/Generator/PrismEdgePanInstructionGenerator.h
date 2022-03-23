//
//  PrismEdgePanInstructionGenerator.h
//  DiDiPrism
//
//  Created by hulk on 2020/9/24.
//

#import <Foundation/Foundation.h>
#import "PrismInstructionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrismEdgePanInstructionGenerator : NSObject
+ (PrismInstructionModel*)getInstructionModelOfEdgePanGesture:(UIScreenEdgePanGestureRecognizer*)edgePanGesture;
@end

NS_ASSUME_NONNULL_END
