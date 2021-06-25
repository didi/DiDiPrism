//
//  PrismControlInstructionGenerator.h
//  DiDiPrism
//
//  Created by hulk on 2020/9/23.
//

#import <Foundation/Foundation.h>
#import "PrismInstructionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrismControlInstructionGenerator : NSObject

+ (NSString*)getInstructionOfControl:(UIControl*)control withTargetAndSelector:(NSString*)targetAndSelector;
+ (PrismInstructionModel*)getInstructionModelOfControl:(UIControl*)control withTargetAndSelector:(NSString*)targetAndSelector;
+ (NSString*)getViewContentOfControl:(UIControl*)control;

@end

NS_ASSUME_NONNULL_END
