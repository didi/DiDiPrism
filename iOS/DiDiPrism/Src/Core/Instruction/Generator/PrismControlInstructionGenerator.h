//
//  PrismControlInstructionGenerator.h
//  DiDiPrism
//
//  Created by hulk on 2020/9/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrismControlInstructionGenerator : NSObject

+ (NSString*)getInstructionOfControl:(UIControl*)control;
+ (NSString*)getFunctionNameOfControl:(UIControl*)control;

@end

NS_ASSUME_NONNULL_END
