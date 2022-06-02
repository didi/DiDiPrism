//
//  PrismCellInstructionStrictParser.m
//  DiDiPrism
//
//  Created by hulk on 2022/3/18.
//

#import "PrismCellInstructionStrictParser.h"
// Category
#import "PrismBaseInstructionParser+Protected.h"
#import "UIView+PrismExtends.h"
#import "NSArray+PrismExtends.h"

@interface PrismCellInstructionStrictParser()

@end

@implementation PrismCellInstructionStrictParser
#pragma mark - life cycle

#pragma mark - public method
- (NSObject *)parseWithFormatter:(PrismInstructionFormatter *)formatter {
    // 解析响应链信息
    NSArray<NSString*> *viewPathArray = [formatter instructionFragmentWithType:PrismInstructionFragmentTypeViewPath];
    UIResponder *responder = [self searchRootResponderWithClassName:[viewPathArray prism_stringWithIndex:1]];
    if (!responder) {
        return nil;
    }
    
    NSArray<UIResponder*> *allPossibleResponder = [NSArray arrayWithObject:responder];
    for (NSInteger index = 2; index < viewPathArray.count; index++) {
        Class class = NSClassFromString(viewPathArray[index]);
        if (!class) {
            break;
        }
        NSArray<UIResponder*> *result = [self searchRespondersWithClassName:viewPathArray[index] superResponders:allPossibleResponder];
        if (!result.count) {
            break;
        }
        allPossibleResponder = result;
    }
    
    
    // vp没有结果，直接返回
    if (allPossibleResponder.count == 0) {
        return nil;
    }
    
    UIView *targetView = [allPossibleResponder.firstObject isKindOfClass:[UIViewController class]] ? [(UIViewController*)allPossibleResponder.firstObject view] : (UIView*)allPossibleResponder.firstObject;
    
    NSArray<NSString*> *viewTreeArray = [formatter instructionFragmentWithType:PrismInstructionFragmentTypeViewTree];
    NSInteger trashElementsCount = 2;// 脏数据个数
    NSInteger viewTreeArrayIndex = 1;
    
    
    NSString *rootViewClassAndIndex = [viewTreeArray prism_stringWithIndex:viewTreeArrayIndex];
    NSArray<NSString *> *viewAndIndex = [rootViewClassAndIndex componentsSeparatedByString:@"|"];
    NSString *cls = viewAndIndex.firstObject;    

    
    if (![cls isEqual:NSStringFromClass(targetView.class)]) {
        return nil;
    }
    
    
    viewTreeArrayIndex ++;
    NSString *subViewClassAndIndex = rootViewClassAndIndex;
    while (targetView.subviews) {
        UIView *resultView = nil;
        subViewClassAndIndex = [viewTreeArray prism_stringWithIndex:viewTreeArrayIndex];
        NSArray<NSString *> *viewAndIndex = [subViewClassAndIndex componentsSeparatedByString:@"|"];
        NSString *cls = viewAndIndex.firstObject;

        if ([targetView isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)targetView;
            NSString *sectionAndRow = viewAndIndex.lastObject;
            NSArray *sectionAndRowArray = [sectionAndRow componentsSeparatedByString:@","];
            NSArray *sectionArray = [sectionAndRowArray.firstObject componentsSeparatedByString:@"("];
            NSArray *rowArray = [sectionAndRowArray.lastObject componentsSeparatedByString:@")"];
            if (sectionArray.count > 0 && rowArray.count > 0) {
                NSInteger section = [sectionArray.lastObject integerValue];
                NSInteger row = [sectionArray.firstObject integerValue];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                __auto_type cell = [tableView cellForRowAtIndexPath:indexPath];
                ///TODO:
                if ([cell isKindOfClass:NSClassFromString(cls)]) {
                    resultView = cell;
                }
            }
        } else if ([targetView isKindOfClass:[UICollectionView class]]) {
            UICollectionView *collectionView = (UICollectionView *)targetView;
            NSString *sectionAndRow = viewAndIndex.lastObject;
            NSArray *sectionAndRowArray = [sectionAndRow componentsSeparatedByString:@","];
            NSArray *sectionArray = [sectionAndRowArray.firstObject componentsSeparatedByString:@"("];
            NSArray *rowArray = [sectionAndRowArray.lastObject componentsSeparatedByString:@")"];
            if (sectionArray.count > 0 && rowArray.count > 0) {
                NSInteger section = [sectionArray.lastObject integerValue];
                NSInteger row = [sectionArray.firstObject integerValue];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                NSArray *visibalCells = [collectionView visibleCells];
                UICollectionViewCell *cell = nil;
                
                if (visibalCells.count > 0) {
                    UICollectionViewCell *minCell = visibalCells.firstObject;
                    NSIndexPath *minIndexPath = [collectionView indexPathForCell:minCell];
                    UICollectionViewCell *maxCell = visibalCells.lastObject;
                    NSIndexPath *maxIndexPath = [collectionView indexPathForCell:maxCell];
                    if (indexPath.section <= maxIndexPath.section &&
                        indexPath.section >= minIndexPath.section &&
                        indexPath.row <= maxIndexPath.row &&
                        indexPath.section >= minIndexPath.row) {
                        cell = [collectionView cellForItemAtIndexPath:indexPath];
                    } else {
                        // 要查询indexPath不在屏幕中
                        targetView = nil;
                        break;
                    }
                    
                } else {
                    // collection没有Cell
                    targetView = nil;
                    break;
                }
                
                if ([cell isKindOfClass:NSClassFromString(cls)]) {
                    resultView = cell;
                } else {
                    // cell Class不匹配
                    targetView = nil;
                    break;
                }
            }
        } else {
            NSInteger index = viewAndIndex.lastObject.integerValue;
            NSMutableArray *subClsViews = @[].mutableCopy;
            [targetView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isMemberOfClass:NSClassFromString(cls)]) {
                    [subClsViews addObject:obj];
                } else {
                    return;
                }
            }];
            
            resultView = [subClsViews prism_objectAtIndex:index];
        }
        
        if (resultView) {
            if (trashElementsCount + viewTreeArrayIndex >= viewTreeArray.count) {
                
                targetView = resultView;
                break;
            } else {
                targetView = resultView;
                viewTreeArrayIndex ++;
            }
        } else {
           
            break;
        }
    }
    
    if (viewTreeArrayIndex == viewTreeArray.count - 2 && !targetView) {
        return nil;
    }
    
    
    
    return targetView;
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
