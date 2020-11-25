//
//  PrismBehaviorTranslater.h
//  DiDiPrism
//
//  Created by hulk on 2020/9/27.
//

#import <Foundation/Foundation.h>
#import "PrismBehaviorTextModel.h"
#import "PrismBehaviorVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrismBehaviorTranslater : NSObject

+ (PrismBehaviorTextModel*)translateWithModel:(PrismBehaviorVideoModel*)model;
@end

NS_ASSUME_NONNULL_END
