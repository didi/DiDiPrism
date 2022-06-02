//
//  PrismInstructionViewTreeChainInfoUtil.m
//  DiDiPrism
//
//  Created by bob on 2022/3/21.
//

#import "PrismInstructionViewTreeChainInfoUtil.h"
#import "UIResponder+PrismIntercept.h"
#import "UIView+PrismExtends.h"

@implementation PrismInstructionViewTreeChainInfoUtil
+ (NSString*)getViewTreeChainInfoWithElement:(UIView *)element {
    if (!element) {
        return nil;
    }
    
    NSMutableString *vt = [NSMutableString stringWithString:@""];
    NSMutableArray<NSString *> *viewsDescriptions = [NSMutableArray array];
    UIViewController *elementFromViewController = [element prism_viewController];

    while (element.superview) {
        UIView *superView = element.superview;
        NSMutableArray *subViews = @[].mutableCopy;
        for (UIView *subview in superView.subviews) {
            if ([NSStringFromClass([subview class]) isEqualToString:NSStringFromClass(element.class)]) { //class为待筛选的类
                [subViews addObject:subview];
            }
        }
        NSInteger index = [subViews indexOfObject:element];
        
        NSString *mark = element.prismAutoDotSpecialMark.length ? element.prismAutoDotSpecialMark : NSStringFromClass([element class]);
        NSString *s = [NSString stringWithFormat:@"%@|%ld_&_", mark, index];
        [viewsDescriptions addObject:s];

        element = superView;
        
        if (elementFromViewController.view && [element isEqual:elementFromViewController.view]) {
            break;
        }
    }
    
    NSString *mark = element.prismAutoDotSpecialMark.length ? element.prismAutoDotSpecialMark : NSStringFromClass([element class]);
    [vt appendFormat:@"%@|0_&_", mark];
    
    [viewsDescriptions enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [vt appendFormat:@"%@", obj];
    }];
    
    return [vt copy];
}

@end
