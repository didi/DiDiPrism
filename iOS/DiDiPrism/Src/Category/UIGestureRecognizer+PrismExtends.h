//
//  UIGestureRecognizer+PrismExtends.h
//  DiDiPrism
//
//  Created by hulk on 2021/6/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIGestureRecognizer (PrismExtends)

@property (nonatomic, copy) NSString *prismAutoDotTargetAndSelector;
@property (nonatomic, copy) NSString *prismAutoDotResponseChainInfo;
@property (nonatomic, copy) NSArray *prismAutoDotAreaInfo;
@end

NS_ASSUME_NONNULL_END
