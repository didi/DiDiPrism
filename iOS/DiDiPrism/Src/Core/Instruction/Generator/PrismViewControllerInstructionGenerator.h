//
//  PrismViewControllerInstructionGenerator.h
//  DiDiPrism
//
//  Created by hulk on 2020/9/25.
//

#import <Foundation/Foundation.h>
#import "PrismInstructionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrismViewControllerInstructionGenerator : NSObject

+ (PrismInstructionModel*)getInstructionModelOfViewController:(UIViewController*)viewController;
@end

NS_ASSUME_NONNULL_END
