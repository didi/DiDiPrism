//
//  NSDate+PrismExtends.h
//  DiDiPrism
//
//  Created by hulk on 2020/10/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (PrismExtends)
- (NSDate *)prism_beginningOfDay;
- (NSDate *)prism_dateByAddingDays:(NSInteger)dDays;
- (NSDate *)prism_dateBySubtractingDays:(NSInteger)dDays;
- (NSInteger)prism_daysBeforeDate:(NSDate *)aDate;
@end

NS_ASSUME_NONNULL_END
