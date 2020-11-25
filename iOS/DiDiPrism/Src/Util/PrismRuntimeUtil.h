//
//  PrismRuntimeUtil.h
//  DiDiPrism
//
//  Created by hulk on 2019/6/27.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrismRuntimeUtil : NSObject

+ (void)hookClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;
+ (void)hookClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector isClassMethod:(BOOL)isClassMethod;
@end

NS_ASSUME_NONNULL_END
