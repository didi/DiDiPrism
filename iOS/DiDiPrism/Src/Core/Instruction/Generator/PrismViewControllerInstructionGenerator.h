//
//  PrismViewControllerInstructionGenerator.h
//  DiDiPrism
//
//  Created by hulk on 2020/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrismViewControllerInstructionGenerator : NSObject

+ (NSString*)getInstructionOfViewController:(UIViewController*)viewController;
@end

NS_ASSUME_NONNULL_END
