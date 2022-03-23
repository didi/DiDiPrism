//
//  PrismCellInstructionGenerator.h
//  DiDiPrism
//
//  Created by hulk on 2020/9/25.
//

#import <Foundation/Foundation.h>
#import "PrismInstructionModel.h"
#import "PrismInstructionEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrismCellInstructionGenerator : NSObject
+ (PrismInstructionModel*)getInstructionModelOfCell:(UIView*)cell;
+ (PrismInstructionModel*)getInstructionModelOfCell:(UIView*)cell withMode:(PrismInstructionMode)mode;
@end

NS_ASSUME_NONNULL_END
