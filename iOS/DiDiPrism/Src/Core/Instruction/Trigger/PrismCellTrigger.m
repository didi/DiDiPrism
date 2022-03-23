//
//  PrismCellTrigger.m
//  DiDiPrism
//
//  Created by hulk on 2022/3/17.
//

#import "PrismCellTrigger.h"
// Category
#import "UIView+PrismExtends.h"

@interface PrismCellTrigger()

@end

@implementation PrismCellTrigger
#pragma mark - life cycle

#pragma mark - public method
- (void)triggerWithElement:(NSObject *)element withDelay:(NSTimeInterval)delaySeconds {
    if ([element isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *targetCell = (UITableViewCell*)element;
        UITableView *tableView = [targetCell prism_UITableViewBelow];
        NSIndexPath *cellIndexPath = [tableView indexPathForCell:targetCell];
        [self highlightTheElement:targetCell withDelay:delaySeconds withCompletion:^{
            if ([tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
                [tableView.delegate tableView:tableView didSelectRowAtIndexPath:cellIndexPath];
            }
        }];
    }
    else if ([element isKindOfClass:[UICollectionViewCell class]]) {
        UICollectionViewCell *targetCell = (UICollectionViewCell*)element;
        UICollectionView *collectionView = [targetCell prism_UICollectionViewBelow];
        NSIndexPath *cellIndexPath = [collectionView indexPathForCell:targetCell];
        [self highlightTheElement:targetCell withDelay:delaySeconds withCompletion:^{
            if ([collectionView.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
                [collectionView.delegate collectionView:collectionView didSelectItemAtIndexPath:cellIndexPath];
            }
        }];
    }
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
