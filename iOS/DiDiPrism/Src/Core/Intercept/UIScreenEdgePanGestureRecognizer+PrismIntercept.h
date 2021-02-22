//
//  UIScreenEdgePanGestureRecognizer+PrismIntercept.h
//  DiDiPrism
//
//  Created by hulk on 2019/10/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScreenEdgePanGestureRecognizer (PrismIntercept)

@property (nonatomic, strong) NSNumber *autoDotViewControllerCount;
@property (nonatomic, weak) UINavigationController *autoDotNavigationController;
@end

NS_ASSUME_NONNULL_END
