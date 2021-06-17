//
//  UIScreenEdgePanGestureRecognizer+PrismIntercept.h
//  DiDiPrism
//
//  Created by hulk on 2019/10/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScreenEdgePanGestureRecognizer (PrismIntercept)

@property (nonatomic, strong) NSNumber *prismAutoDotViewControllerCount;
@property (nonatomic, weak) UINavigationController *prismAutoDotNavigationController;
@end

NS_ASSUME_NONNULL_END
