//
//  UIView+PrismExtends.h
//  DiDiPrism
//
//  Created by hulk on 2020/9/23.
//
//

#import <UIKit/UIKit.h>

@interface UIView (PrismExtends)

- (UITableView*)prism_UITableViewBelow;
- (UICollectionView*)prism_UICollectionViewBelow;
- (UIViewController *)prism_viewController;
- (id)prism_wxComponent;

@end
