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
+ (PrismInstructionModel *)getInstructionModelOfControl:(UIControl *)control
                                  withTargetAndSelector:(NSString *)targetAndSelector
                                      withControlEvents:(NSString*)controlEvents;
+ (NSString*)getViewContentOfControl:(UIControl*)control;

@end

NS_ASSUME_NONNULL_END
