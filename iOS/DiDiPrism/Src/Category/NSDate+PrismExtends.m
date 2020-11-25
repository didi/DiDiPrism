//
//  NSDate+PrismExtends.m
//  DiDiPrism
//
//  Created by hulk on 2020/10/11.
//

#import "NSDate+PrismExtends.h"

@implementation NSDate (PrismExtends)
#pragma mark - public method
- (NSDate *)prism_beginningOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    return [calendar dateFromComponents:components];
}

- (NSDate *)prism_dateByAddingDays:(NSInteger)dDays {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 86400 * dDays;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)prism_dateBySubtractingDays:(NSInteger)dDays {
    return [self prism_dateByAddingDays:(dDays * -1)];
}

- (NSInteger)prism_daysBeforeDate:(NSDate *)aDate {
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(ti / 86400);
}


@end
