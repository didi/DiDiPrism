//
//  NSDictionary+PrismExtends.h
//  DiDiPrism
//
//  Created by hulk on 2020/9/23.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary <KeyType, ObjectType> (PrismExtends)

- (id)prism_objectForKey:(id<NSCopying>)key;
- (NSInteger)prism_integerForKey:(id<NSCopying>)key;
- (NSString*)prism_stringForKey:(KeyType <NSCopying>)key;
- (NSArray*)prism_arrayForKey:(KeyType <NSCopying>)key;
- (NSNumber *)prism_numberForKey:(id<NSCopying>)key;
- (NSDictionary*)prism_dictionaryForKey:(id<NSCopying>)key;

@end

@interface NSMutableDictionary <KeyType, ObjectType> (PrismExtends)

- (void)prism_setValue:(ObjectType)aValue forKey:(KeyType <NSCopying>)key;

@end
