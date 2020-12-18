//
//  PrismBaseInstructionParser+Protected.m
//  DiDiPrism
//
//  Created by hulk on 2019/7/25.
//

#import "PrismBaseInstructionParser+Protected.h"
// Category
#import "UIView+PrismExtends.h"
// Util
#import "PrismInstructionAreaUtil.h"

@implementation PrismBaseInstructionParser (Protected)
- (UIResponder*)searchRootResponderWithClassName:(NSString*)className {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if ([keyWindow isKindOfClass:NSClassFromString(className)]) {
        return keyWindow;
    }
    if ([keyWindow.rootViewController isKindOfClass:NSClassFromString(className)]) {
        return keyWindow.rootViewController;
    }
    // 考虑presentViewController的情况
    __block UIViewController *presentedVC = nil;
    [[keyWindow subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UITransitionView")] && [[obj subviews] count]) {
            UIView *aimView = (UIView*)[obj subviews][0];
            if ([[aimView nextResponder] isKindOfClass:[UIViewController class]]) {
                presentedVC = (UIViewController*)[aimView nextResponder];
            }
            else {
                presentedVC = [((UIView*)[obj subviews][0]) prism_viewController];
            }
            *stop = YES;
        }
    }];
    return presentedVC;
}

- (UIView*)searchScrollViewCellWithScrollViewClassName:(NSString*)scrollViewClassName
                                         cellClassName:(NSString*)cellClassName
                                  cellSectionOrOriginX:(CGFloat)cellSectionOrOriginX
                                      cellRowOrOriginY:(CGFloat)cellRowOrOriginY
                                         fromSuperView:(UIView*)superView {
    if (!superView.subviews.count) {
        return nil;
    }
    for (UIView *view in superView.subviews) {
        if ([view isKindOfClass:NSClassFromString(scrollViewClassName)]) {
            UIScrollView *scrollView = (UIScrollView*)view;
            if ([scrollView isKindOfClass:[UITableView class]]
                && [NSClassFromString(cellClassName) isSubclassOfClass:[UITableViewCell class]]) {
                UITableView *tableView = (UITableView*)scrollView;
                NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:[NSNumber numberWithFloat:cellRowOrOriginY].integerValue inSection:[NSNumber numberWithFloat:cellSectionOrOriginX].integerValue];
                NSInteger numbersOfSections = [tableView numberOfSections];
                if (numbersOfSections > cellIndexPath.section
                    && [tableView numberOfRowsInSection:cellIndexPath.section] > cellIndexPath.row) {
                    [tableView scrollToRowAtIndexPath:cellIndexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
                    self.didScroll = YES;
                    UITableViewCell *cell = [tableView cellForRowAtIndexPath:cellIndexPath];
                    if (![cell isKindOfClass:NSClassFromString(cellClassName)]) {
                        // 兼容indexPath.row小幅度漂移场景。
                        for (UITableViewCell *tempCell in [tableView visibleCells]) {
                            if ([tempCell isKindOfClass:NSClassFromString(cellClassName)]) {
                                cell = tempCell;
                                break;
                            }
                        }
                    }
                    if (cell && [cell isKindOfClass:NSClassFromString(cellClassName)]) {
                        return cell;
                    }
                }
                // 兜底处理
                // 如果是通常列表形式的（只有一个section，并且cell类型都一样，而且都不是系统默认类型的(WEEX除外)），取已有的最后一个作为代替。
                if (numbersOfSections == 1 &&
                    numbersOfSections > cellIndexPath.section &&
                    (![cellClassName isEqualToString:NSStringFromClass([UITableViewCell class])] || [tableView isKindOfClass:NSClassFromString(@"WXTableView")])) {
                    NSInteger tolerantRow = [tableView numberOfRowsInSection:cellIndexPath.section] - 1;
                    if (tolerantRow >= 0) {
                        NSIndexPath *tolerantIndexPath = [NSIndexPath indexPathForRow:tolerantRow inSection:cellIndexPath.section];
                        [tableView scrollToRowAtIndexPath:tolerantIndexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
                        self.didScroll = YES;
                        BOOL isAllSameKind = YES;
                        NSInteger rowsInSection = [tableView numberOfRowsInSection:cellIndexPath.section];
                        for (NSInteger row = 0; row < rowsInSection; row++) {
                            UITableViewCell *rowCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:cellIndexPath.section]];
                            if (rowCell && ![rowCell isKindOfClass:NSClassFromString(cellClassName)]) {
                                isAllSameKind = NO;
                            }
                        }
                        if (isAllSameKind) {
                            return [tableView cellForRowAtIndexPath:tolerantIndexPath];
                        }
                    }
                }
            }
            else if ([scrollView isKindOfClass:[UICollectionView class]]
                     && [NSClassFromString(cellClassName) isSubclassOfClass:[UICollectionViewCell class]]) {
                UICollectionView *collectionView = (UICollectionView*)scrollView;
                NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:[NSNumber numberWithFloat:cellRowOrOriginY].integerValue inSection:[NSNumber numberWithFloat:cellSectionOrOriginX].integerValue];
                NSInteger numbersOfSections = [collectionView numberOfSections];
                if (numbersOfSections > cellIndexPath.section
                    && [collectionView numberOfItemsInSection:cellIndexPath.section] > cellIndexPath.row) {
                    [collectionView scrollToItemAtIndexPath:cellIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                    self.didScroll = YES;
                    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:cellIndexPath];
                    if (![cell isKindOfClass:NSClassFromString(cellClassName)]) {
                        // 兼容indexPath.row小幅度漂移场景。
                        for (UICollectionViewCell *tempCell in [collectionView visibleCells]) {
                            if ([tempCell isKindOfClass:NSClassFromString(cellClassName)]) {
                                cell = tempCell;
                                break;
                            }
                        }
                    }
                    if (cell && [cell isKindOfClass:NSClassFromString(cellClassName)]) {
                        return cell;
                    }
                }
                // 兜底处理
                // 如果是通常列表形式的（只有一个section，并且cell类型都一样，而且都不是系统默认类型的(WEEX除外)），取已有的最后一个作为代替。
                if (numbersOfSections == 1 &&
                    numbersOfSections > cellIndexPath.section &&
                    (![cellClassName isEqualToString:NSStringFromClass([UICollectionViewCell class])] || [collectionView isKindOfClass:NSClassFromString(@"WXCollectionView")])) {
                    NSInteger tolerantRow = [collectionView numberOfItemsInSection:cellIndexPath.section] - 1;
                    if (tolerantRow >= 0) {
                        NSIndexPath *tolerantIndexPath = [NSIndexPath indexPathForRow:tolerantRow inSection:cellIndexPath.section];
                        [collectionView scrollToItemAtIndexPath:tolerantIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                        self.didScroll = YES;
                        BOOL isAllSameKind = YES;
                        NSInteger rowsInSection = [collectionView numberOfItemsInSection:cellIndexPath.section];
                        for (NSInteger row = 0; row < rowsInSection; row++) {
                            UICollectionViewCell *rowCell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:cellIndexPath.section]];
                            if (rowCell && ![rowCell isKindOfClass:NSClassFromString(cellClassName)]) {
                                isAllSameKind = NO;
                            }
                        }
                        if (isAllSameKind) {
                            return [collectionView cellForItemAtIndexPath:tolerantIndexPath];
                        }
                    }
                }
            }
            else {
                for (UIView *subview in scrollView.subviews) {
                    if ([subview isKindOfClass:NSClassFromString(cellClassName)]) {
                        
                        NSInteger subviewIndex = [PrismInstructionAreaUtil getIndexOf:subview fromScrollView:scrollView];
                        if (subviewIndex == cellSectionOrOriginX) {
                            CGPoint offset = CGPointMake(subview.frame.origin.x > 50 ? subview.frame.origin.x - 50 : subview.frame.origin.x, subview.frame.origin.y > 100 ? subview.frame.origin.y - 100 : subview.frame.origin.y);
                            [scrollView setContentOffset:offset animated:NO];
                            self.didScroll = YES;
                            return subview;
                        }
                    }
                }
            }
        }
        UIView *scrollViewCell = [self searchScrollViewCellWithScrollViewClassName:scrollViewClassName
                                                                     cellClassName:cellClassName
                                                              cellSectionOrOriginX:cellSectionOrOriginX
                                                                  cellRowOrOriginY:cellRowOrOriginY
                                                                     fromSuperView:view];
        if (scrollViewCell) {
            return scrollViewCell;
        }
    }
    return nil;
}

- (UIResponder*)searchResponderWithClassName:(NSString*)className superResponder:(UIResponder*)superResponder {
    if ([superResponder isKindOfClass:[UIViewController class]]) {
        UIViewController *viewController = (UIViewController*)superResponder;
        for (UIViewController *responder in viewController.childViewControllers) {
            // 场景：一个viewController下有4个同样的子viewController。
            if ([responder isKindOfClass:NSClassFromString(className)] && responder.view.superview) {
                if ([superResponder isKindOfClass:[UINavigationController class]]) {
                    UINavigationController *navController = (UINavigationController*)superResponder;
                    if (navController.topViewController == responder
                        || navController.visibleViewController == responder) {
                        return responder;
                    }
                }
                else {
                    return responder;
                }
            }
        }
    }
    else if ([superResponder isKindOfClass:[UIView class]]) {
        UIView *view = (UIView*)superResponder;
        for (UIResponder *responder in [view subviews]) {
            if ([responder isKindOfClass:NSClassFromString(className)]) {
                return responder;
            }
        }
    }
    return nil;
}

- (void)scrollToIdealOffsetWithScrollView:(UIScrollView*)scrollView targetElement:(UIView*)targetElement {
    if (!scrollView) {
        return;
    }
    UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
    BOOL isInWindow = CGRectContainsRect(mainWindow.bounds, [targetElement convertRect:targetElement.bounds toView:mainWindow]);
    if (!isInWindow
        && [scrollView isKindOfClass:[UIScrollView class]]
        && !CGSizeEqualToSize(scrollView.contentSize, CGSizeZero)) {
        CGRect targetRect = [targetElement convertRect:targetElement.bounds toView:scrollView];
        CGPoint offset = scrollView.contentSize.height > 0 ? CGPointMake(0, targetRect.origin.y - 200) : CGPointMake(targetRect.origin.x - 100, 0);
        [scrollView setContentOffset:offset animated:NO];
    }
}

- (void)highlightTheElement:(UIView*)element withCompletion:(void(^)(void))block {
    NSTimeInterval delaySeconds = self.didScroll ? 0.5 : 0;
    self.didScroll = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
        CGRect elementFrame = [element.superview convertRect:element.frame toView:mainWindow];
        UIBezierPath *redPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(elementFrame.origin.x - 4, elementFrame.origin.y - 4, elementFrame.size.width + 8, elementFrame.size.height + 8) cornerRadius:5];
        CAShapeLayer *redLayer = [CAShapeLayer layer];
        redLayer.path = redPath.CGPath;
        redLayer.fillColor = [UIColor redColor].CGColor;
        redLayer.opacity = 0.3;
        [mainWindow.layer addSublayer:redLayer];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.needExecute && block) {
                block();
            }
            [redLayer removeFromSuperlayer];
        });
    });
}

- (BOOL)isAreaInfoEqualBetween:(NSString*)one withAnother:(NSString*)another allowCompatibleMode:(BOOL)allowCompatibleMode {
    if (!self.isCompatibleMode || !allowCompatibleMode) {
        return [one isEqualToString:another];
    }
    else {
        if ([one isEqualToString:another]) {
            return YES;
        }
        // 兼容模式下，正上、正下、正左、正右 可以有偏差。
        // 即 2可以等于8/10，3可以等于12/15，4可以等于8/12，5可以等于10/15
        NSDictionary *dictionary = @{@"2":@[@"8",@"10"],@"3":@[@"12",@"15"],@"4":@[@"8",@"12"],@"5":@[@"10",@"15"]};
        if (!([dictionary.allKeys containsObject:one] && [dictionary.allKeys containsObject:another])) {
            if ([dictionary.allKeys containsObject:one]) {
                NSArray *oneBox = dictionary[one];
                if ([oneBox containsObject:another]) {
                    return YES;
                }
            }
            else if ([dictionary.allKeys containsObject:another]) {
                NSArray *anotherBox = dictionary[another];
                if ([anotherBox containsObject:one]) {
                    return YES;
                }
            }
        }
    }
    return NO;
}
@end
