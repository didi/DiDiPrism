//
//  PrismDataFloatingComponent.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import "PrismDataFloatingComponent.h"
// View
#import "PrismDataFloatingView.h"

@interface PrismDataFloatingComponent()

@end

@implementation PrismDataFloatingComponent

- (void)dispatchEvent:(PrismDispatchEvent)event withSender:(NSObject *)sender params:(NSDictionary *)params {
    if (event == PrismDispatchEventUIViewDidMoveToSuperview) {
        UIView *view = (UIView*)sender;
        if (view.alpha == 0
            || view.hidden == YES
            || ![PrismIdentifierUtil needHookWithView:view]) {
            return;
        }
        //等待加载完成，比如动画效果、数据渲染等
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if ([EDPivot EDMode] == EasyDotModeDisabled
//                || senderView.easyDotDisplayMode != EasyDotDataDisplayModeNatural
//                || !senderView.easyDotEventInfos.count
//                || senderView.alpha == 0
//                || senderView.hidden == YES
//                || ![EDViewUtils needHookWithView:senderView]) {
//                return;
//            }
//            [[EDDotLookViewManager sharedManager] showElementDataViewInSuperview:senderView ignoreParameters:NO];
            
            PrismDataFloatingView *floatingView = [[PrismDataFloatingView alloc] init];
            PrismDataFloatingModel *model = [[PrismDataFloatingModel alloc] init];
            model.content = @"123";
            model.flagContent = @"位置:1";
            model.value = 123;
            floatingView.model = model;
            
            
            BOOL needResize = view.frame.size.width < MinWidthOfPrismDataFloatingView || view.frame.size.height < MinHeightOfPrismDataFloatingView;
            if (needResize && (view.clipsToBounds || view.layer.masksToBounds)) {
                [self removeDataViewFrom:view.superview];
                [view.superview addSubview:floatingView];
            }
            else {
                [self removeDataViewFrom:view];
                [view addSubview:floatingView];
            }
            //trigger setter
            floatingView.frame = CGRectZero;
        });
    }
}

#pragma mark - private method
- (void)removeDataViewFrom:(UIView*)superview {
    UIView *theView = nil;
    NSArray<UIView*> *subviews = [superview subviews];
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[PrismDataFloatingView class]]) {
            theView = subview;
            break;
        }
    }
    [theView removeFromSuperview];
}
@end
