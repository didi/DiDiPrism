//
//  PrismDataFloatingComponent.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import "PrismDataFloatingComponent.h"
#import "UIView+PrismExtends.h"
#import "UIView+PrismDataVisualization.h"
// View
#import "PrismDataFloatingView.h"

@interface PrismDataFloatingComponent()
@property (nonatomic, strong) NSMutableArray<PrismDataFloatingView*> *allFloatingViews;
@end

@implementation PrismDataFloatingComponent

- (void)dispatchEvent:(PrismDispatchEvent)event withSender:(NSObject *)sender params:(NSDictionary *)params {
    if (event == PrismDispatchEventUIViewDidMoveToSuperview) {
        UIView *view = (UIView*)sender;
        if (!view.relatedInfos.count
            || view.alpha == 0
            || view.hidden == YES
            || ![PrismIdentifierUtil needHookWithView:view]) {
            return;
        }
        //等待加载完成，比如动画效果、数据渲染等
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            PrismDataFloatingView *floatingView = [self viewWithRelatedInfos:view.relatedInfos onSuperview:view ignoreParameters:NO];
            BOOL isNewFloatingView = !floatingView;
            if (isNewFloatingView) {
                floatingView = [[PrismDataFloatingView alloc] init];
                floatingView.relatedInfos = [view.relatedInfos copy];
                [self.allFloatingViews addObject:floatingView];
                
                PrismDataFloatingModel *model = [[PrismDataFloatingModel alloc] init];
                model.content = @"123";
                model.flagContent = @"位置:1";
                model.value = 123;
                floatingView.model = model;
            }
            floatingView.hidden = ![self enable];
            if (![floatingView superview]) {
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
            }
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

- (PrismDataFloatingView*)viewWithRelatedInfos:(PrismElementRelatedInfos*)relatedInfos
                                   onSuperview:(UIView*)superview
                              ignoreParameters:(BOOL)ignoreParameters {
    for (PrismDataFloatingView *view in self.allFloatingViews) {
        BOOL isClickIdEqual = [view.relatedInfos clickTypeEventId].length ? [[view.relatedInfos clickTypeEventId] isEqualToString:[relatedInfos clickTypeEventId]] : YES;
        BOOL isExposureIdEqual = [view.relatedInfos exposureTypeEventId].length ? [[view.relatedInfos exposureTypeEventId] isEqualToString:[relatedInfos exposureTypeEventId]] : YES;
        BOOL isEqual = ignoreParameters ? (isClickIdEqual && isExposureIdEqual) : [view.relatedInfos isEqual:relatedInfos];
        if (isEqual && (!view.superview || [view.superview prism_hasRelationshipsWithView:superview])) {
            return view;
        }
    }
    return nil;
}

#pragma mark - setters
- (void)setEnable:(BOOL)enable {
    [super setEnable:enable];
    
    if (self.enable) {
        
    }
    else {
        
    }
}

#pragma mark - getters
- (NSMutableArray<PrismDataFloatingView *> *)allFloatingViews {
    if (!_allFloatingViews) {
        _allFloatingViews = [NSMutableArray array];
    }
    return _allFloatingViews;
}
@end
