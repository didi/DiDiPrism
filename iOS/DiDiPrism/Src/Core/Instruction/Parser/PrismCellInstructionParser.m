//
//  PrismCellInstructionParser.m
//  DiDiPrism
//
//  Created by hulk on 2019/7/25.
//

#import "PrismCellInstructionParser.h"
// Util
#import "PrismInstructionContentUtil.h"
// Category
#import "PrismBaseInstructionParser+Protected.h"
#import "UIView+PrismExtends.h"
#import "NSArray+PrismExtends.h"

@interface PrismCellInstructionParser()

@end

@implementation PrismCellInstructionParser
#pragma mark - life cycle

#pragma mark - public method
- (PrismInstructionParseResult)parseWithFormatter:(PrismInstructionFormatter *)formatter {
    // 解析响应链信息
    NSArray<NSString*> *viewPathArray = [formatter instructionFragmentWithType:PrismInstructionFragmentTypeViewPath];
    UIResponder *responder = [self searchRootResponderWithClassName:[viewPathArray prism_stringWithIndex:1]];
    if (!responder) {
        return PrismInstructionParseResultFail;
    }
    
    for (NSInteger index = 2; index < viewPathArray.count; index++) {
        Class class = NSClassFromString(viewPathArray[index]);
        if (!class) {
            break;
        }
        UIResponder *result = [self searchResponderWithClassName:viewPathArray[index] superResponder:responder];
        if (!result) {
            break;
        }
        responder = result;
    }
    
    // 解析列表信息
    NSArray<NSString*> *viewListArray = [formatter instructionFragmentWithType:PrismInstructionFragmentTypeViewList];
    UIView *targetView = [responder isKindOfClass:[UIViewController class]] ? [(UIViewController*)responder view] : (UIView*)responder;
    for (NSInteger index = 1; index < viewListArray.count; index = index + 4) {
        if ([NSClassFromString(viewListArray[index]) isSubclassOfClass:[UIScrollView class]]) {
            NSString *scrollViewClassName = viewListArray[index];
            NSString *cellClassName = viewListArray[index + 1];
            CGFloat cellSectionOrOriginX = viewListArray[index + 2].floatValue;
            CGFloat cellRowOrOriginY = viewListArray[index + 3].floatValue;
            UIView *scrollViewCell = [self searchScrollViewCellWithScrollViewClassName:scrollViewClassName
                                                                         cellClassName:cellClassName
                                                                  cellSectionOrOriginX:cellSectionOrOriginX
                                                                      cellRowOrOriginY:cellRowOrOriginY
                                                                         fromSuperView:targetView];
            if (!scrollViewCell) {
                return PrismInstructionParseResultFail;
            }
            targetView = scrollViewCell;
        }
    }
    
    if (targetView) {
        NSArray<NSString*> *viewRepresentativeContentArray = [formatter instructionFragmentWithType:PrismInstructionFragmentTypeViewRepresentativeContent];
        NSString *representativeContent = [viewRepresentativeContentArray prism_stringWithIndex:1];
        if ([targetView isKindOfClass:[UITableViewCell class]]) {
            UITableView *tableView = [targetView prism_UITableViewBelow];
            UITableViewCell *targetCell = (UITableViewCell*)targetView;
            NSString *viewContent = [PrismInstructionContentUtil getRepresentativeContentOfView:targetCell needRecursive:YES];
            if (![viewContent containsString:representativeContent]) {
                for (UITableViewCell *cell in [tableView visibleCells]) {
                    viewContent = [PrismInstructionContentUtil getRepresentativeContentOfView:cell needRecursive:YES];
                    if ([viewContent containsString:representativeContent]) {
                        targetCell = cell;
                        break;
                    }
                }
            }
            NSIndexPath *cellIndexPath = [tableView indexPathForCell:targetCell];
            [self highlightTheElement:targetCell withCompletion:^{
                if ([tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
                    [tableView.delegate tableView:tableView didSelectRowAtIndexPath:cellIndexPath];
                }
            }];
            return PrismInstructionParseResultSuccess;
        }
        else if ([targetView isKindOfClass:[UICollectionViewCell class]]) {
            UICollectionView *collectionView = [targetView prism_UICollectionViewBelow];
            UICollectionViewCell *targetCell = (UICollectionViewCell*)targetView;
            NSString *viewContent = [PrismInstructionContentUtil getRepresentativeContentOfView:targetCell needRecursive:YES];
            if (![viewContent containsString:representativeContent]) {
                for (UICollectionViewCell *cell in [collectionView visibleCells]) {
                    viewContent = [PrismInstructionContentUtil getRepresentativeContentOfView:cell needRecursive:YES];
                    if ([viewContent containsString:representativeContent]) {
                        targetCell = cell;
                        break;
                    }
                }
            }
            NSIndexPath *cellIndexPath = [collectionView indexPathForCell:targetCell];
            [self highlightTheElement:targetCell withCompletion:^{
                if ([collectionView.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
                    [collectionView.delegate collectionView:collectionView didSelectItemAtIndexPath:cellIndexPath];
                }
            }];
            return PrismInstructionParseResultSuccess;
        }
    }
    return PrismInstructionParseResultFail;
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
