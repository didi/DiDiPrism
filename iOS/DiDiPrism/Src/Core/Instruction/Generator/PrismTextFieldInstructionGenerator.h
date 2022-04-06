//
//  PrismTextFieldInstructionGenerator.h
//  DiDiPrism
//
//  Created by hulk on 2022/4/2.
//

#import <Foundation/Foundation.h>
#import "PrismInstructionModel.h"
#import "PrismDispatchEventDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrismTextFieldInstructionGenerator : NSObject
+ (PrismInstructionModel*)getInstructionModelOfTextField:(UITextField*)textField withEvent:(PrismDispatchEvent)event;
@end

NS_ASSUME_NONNULL_END
