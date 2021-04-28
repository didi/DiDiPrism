//
//  PrismIdentifierUtil.h
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrismIdentifierUtil : NSObject
+ (NSString *)identifier;
+ (BOOL)needHookWithView:(UIView *)view;
+ (BOOL)needHookWithGesture:(UIGestureRecognizer *)gesture;
@end

NS_ASSUME_NONNULL_END
