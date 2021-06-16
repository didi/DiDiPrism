//
//  PrismInstructionAreaInfoUtil.m
//  DiDiPrism
//
//  Created by hulk on 2019/7/1.
//

#import "PrismInstructionAreaInfoUtil.h"
// Category
#import "UIView+PrismExtends.h"

@implementation PrismInstructionAreaInfoUtil
#pragma mark - public method
/*
 @return 数组，[0]为vl，[1]为vq
 */
+ (NSArray<NSString*>*)getAreaInfoWithElement:(UIView *)element {
    if (!element || ![element superview]) {
        return @[@"", [NSString stringWithFormat:@"%ld", PrismInstructionAreaUnknown]];
    }
    BOOL isAllPagingEnabled = YES;
    // 列表信息
    NSMutableString *listInfo = [NSMutableString string];
    UIResponder *temporaryView = element;
    UIResponder *temporarySuperview = temporaryView.nextResponder;
    while (temporaryView && ![temporaryView isKindOfClass:[UIViewController class]]) {
        if ([temporaryView isKindOfClass:[UITableViewCell class]]) {
            UITableViewCell *tableViewCell = (UITableViewCell*)temporaryView;
            UITableView *tableView = [tableViewCell prism_UITableViewBelow];
            isAllPagingEnabled = !tableView.isPagingEnabled ? NO : isAllPagingEnabled;
            NSIndexPath *indexPath = [tableView indexPathForCell:tableViewCell];
            if (!indexPath) {
                indexPath = [tableView indexPathForRowAtPoint:tableViewCell.center];
            }
            NSString *thisScrollInfo = [NSString stringWithFormat:@"%@_&_%@_&_%ld_&_%ld_&_", NSStringFromClass([tableView class]), NSStringFromClass([tableViewCell class]), (long)indexPath.section, (long)indexPath.row];
            [listInfo insertString:thisScrollInfo atIndex:0];
        }
        else if ([temporaryView isKindOfClass:[UICollectionViewCell class]]) {
            UICollectionViewCell *collectionViewCell = (UICollectionViewCell*)temporaryView;
            UICollectionView *collectionView = [collectionViewCell prism_UICollectionViewBelow];
            isAllPagingEnabled = !collectionView.isPagingEnabled ? NO : isAllPagingEnabled;
            NSIndexPath *indexPath = [collectionView indexPathForCell:collectionViewCell];
            if (!indexPath) {
                indexPath = [collectionView indexPathForItemAtPoint:collectionViewCell.center];
            }
            NSString *thisScrollInfo = [NSString stringWithFormat:@"%@_&_%@_&_%ld_&_%ld_&_", NSStringFromClass([collectionView class]), NSStringFromClass([collectionViewCell class]), (long)indexPath.section, (long)indexPath.row];
            [listInfo insertString:thisScrollInfo atIndex:0];
        }
        else if ([temporarySuperview isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView*)temporarySuperview;
            isAllPagingEnabled = !scrollView.isPagingEnabled ? NO : isAllPagingEnabled;
            NSInteger index = [self getIndexOf:(UIView*)temporaryView fromScrollView:scrollView];
            NSString *thisScrollInfo = [NSString stringWithFormat:@"%@_&_%@_&_%ld_&_%ld_&_", NSStringFromClass([scrollView class]), NSStringFromClass([temporaryView class]), index, index];
            [listInfo insertString:thisScrollInfo atIndex:0];
        }
        
        temporaryView = temporaryView.nextResponder;
        temporarySuperview = temporaryView.nextResponder;
    }
    
    // 区位信息
    UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
    CGRect rectInWindow = [element convertRect:element.bounds toView:mainWindow];
    CGPoint centerOfElement = CGPointMake(rectInWindow.origin.x + rectInWindow.size.width / 2, rectInWindow.origin.y + rectInWindow.size.height / 2);
    
    NSInteger horizontalValue = PrismInstructionAreaUnknown;
    if (centerOfElement.x == mainWindow.center.x) {
        horizontalValue = PrismInstructionAreaCenter;
    }
    else if (centerOfElement.x < mainWindow.center.x) {
        horizontalValue = PrismInstructionAreaLeft;
    }
    else {
        horizontalValue = PrismInstructionAreaRight;
    }
    NSInteger verticalValue = PrismInstructionAreaUnknown;
    if (centerOfElement.y == mainWindow.center.y) {
        verticalValue = PrismInstructionAreaCenter;
    }
    else if (centerOfElement.y < mainWindow.center.y) {
        verticalValue = PrismInstructionAreaUp;
    }
    else {
        verticalValue = PrismInstructionAreaBottom;
    }
    NSInteger coordAtScreen = isAllPagingEnabled == NO ? PrismInstructionAreaCanScroll : horizontalValue * verticalValue;
    
    return @[listInfo.length ? [listInfo copy] : @"", [NSString stringWithFormat:@"%ld", coordAtScreen]];
}

+ (NSInteger)getIndexOf:(UIView*)element fromScrollView:(UIScrollView*)scrollView {
    BOOL isHorizontal = scrollView.contentSize.width > scrollView.frame.size.width;
    BOOL isVertical = scrollView.contentSize.height > scrollView.frame.size.height;
    NSArray<UIView*> *subviews = [scrollView subviews];
    NSArray<UIView*> *sortedSubviews =[subviews sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        UIView *view1 = obj1;
        UIView *view2 = obj2;
        CGFloat value1 = view1.frame.origin.y;
        CGFloat value2 = view2.frame.origin.y;
        if (isVertical) {
            value1 = view1.frame.origin.y;
            value2 = view2.frame.origin.y;
        }
        else if (isHorizontal) {
            value1 = view1.frame.origin.x;
            value2 = view2.frame.origin.x;
        }
        
        if ( value1 < value2 ) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if ( value1 > value2 ) {
            return (NSComparisonResult)NSOrderedDescending;
        } else {
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    
    return [sortedSubviews indexOfObject:element];
}

#pragma mark - private method
@end
