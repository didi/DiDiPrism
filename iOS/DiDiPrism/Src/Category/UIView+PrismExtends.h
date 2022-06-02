//
//  UIView+PrismExtends.h
//  DiDiPrism
//
//  Created by hulk on 2020/9/23.
//
//

#import <UIKit/UIKit.h>

@interface UIView (PrismExtends)

- (UIScrollView*)prism_UIScrollViewBelow;
- (UITableView*)prism_UITableViewBelow;
- (UICollectionView*)prism_UICollectionViewBelow;
- (UIViewController *)prism_viewController;
- (id)prism_wxComponent;
- (BOOL)prism_hasRelationshipsWithView:(UIView*)view;
@end
