//
//  PrismInstructionContentUtil.h
//  DiDiPrism
//
//  Created by hulk on 2020/5/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrismInstructionContentUtil : NSObject
+ (NSString*)getRepresentativeContentOfView:(UIView*)view needRecursive:(BOOL)needRecursive;
@end

NS_ASSUME_NONNULL_END
