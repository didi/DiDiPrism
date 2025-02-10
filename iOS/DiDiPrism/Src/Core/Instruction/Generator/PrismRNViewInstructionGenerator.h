//
//  PrismRNViewInstructionGenerator.h
//  DiDiPrism
//
//  Created by hulk on 2025/2/8.
//

#import <Foundation/Foundation.h>
#import "PrismInstructionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrismRNViewInstructionGenerator : NSObject
+ (PrismInstructionModel *)getInstructionModelOfView:(UIView *)view withPageInfo:(NSString*)pageInfo;
@end

NS_ASSUME_NONNULL_END
