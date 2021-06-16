//
//  PrismCellInstructionGenerator.h
//  DiDiPrism
//
//  Created by hulk on 2020/9/25.
//

#import <Foundation/Foundation.h>
#import "PrismInstructionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrismCellInstructionGenerator : NSObject

+ (NSString*)getInstructionOfCell:(UIView*)cell;
+ (PrismInstructionModel*)getInstructionModelOfCell:(UIView*)cell;
@end

NS_ASSUME_NONNULL_END
