//
//  NSArray+PrismExtends.m
//  DiDiPrism
//
//  Created by hulk on 2020/9/23.
//
//

#import "NSArray+PrismExtends.h"

@implementation NSArray (PrismExtends)
#pragma mark - public method
- (id)prism_objectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return self[index];
    }else{
        return nil;
    }
}

- (NSString*)prism_stringWithIndex:(NSUInteger)index{
    id value = [self prism_objectAtIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString*)value;
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    
    return nil;
}

@end

@implementation NSMutableArray(PrismExtends)

- (void)prism_addObject:(id)object{
    if (object == nil) {
        return;
    }
    [self addObject:object];
}

@end
