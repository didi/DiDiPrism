//
//  NSArray+PrismExtends.h
//  DiDiPrism
//
//  Created by hulk on 2020/9/23.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (PrismExtends)

- (id)prism_objectAtIndex:(NSUInteger)index;
- (NSString*)prism_stringWithIndex:(NSUInteger)index;

@end

@interface NSMutableArray(PrismExtends)

- (void)prism_addObject:(id)object;

@end


NS_ASSUME_NONNULL_END
