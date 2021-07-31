//
//  NSDictionary+PrismExtends.m
//  DiDiPrism
//
//  Created by hulk on 2020/9/23.
//
//

#import "NSDictionary+PrismExtends.h"

@implementation NSDictionary (PrismExtends)
- (id)prism_objectForKey:(id<NSCopying>)key {
    if(!key){
        return nil;
    }
    
    id value = [self objectForKey:key];
    
    if(value && [value isKindOfClass:[NSNull class]]){
        return nil;
    }
    
    return value;
}

- (NSInteger)prism_integerForKey:(id<NSCopying>)key {
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value integerValue];
    }
    
    return 0;
}

- (NSString *)prism_stringForKey:(id<NSCopying>)key {
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString*)value;
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    
    return nil;
}

- (NSArray*)prism_arrayForKey:(id<NSCopying>)key {
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }
    
    return nil;
}

- (NSNumber *)prism_numberForKey:(id<NSCopying>)key {
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)value;
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        return [f numberFromString:(NSString*)value];
    }
    
    return nil;
}

- (NSDictionary*)prism_dictionaryForKey:(id<NSCopying>)key {
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    
    return nil;
}

@end

@implementation NSMutableDictionary (PrismExtends)
- (void)prism_setValue:(id)i forKey:(id<NSCopying>)key {
    if (!key) {
        NSParameterAssert(key);
        return;
    }
    
    if (i != nil) {
        [self setObject:i forKey:key];
    }
}

@end

