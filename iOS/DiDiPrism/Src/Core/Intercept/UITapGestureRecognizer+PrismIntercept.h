//
//  UITapGestureRecognizer+PrismIntercept.h
//  DiDiPrism
//
//  Created by hulk on 2019/6/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITapGestureRecognizer (PrismIntercept)

@property (nonatomic, copy) NSString *autoDotTargetAndSelector;
@property (nonatomic, copy) NSString *autoDotResponseChainInfo;
@property (nonatomic, copy) NSString *autoDotAreaInfo;
@end

NS_ASSUME_NONNULL_END
