//
//  PrismDataFloatingComponent.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import "PrismDataFloatingComponent.h"
#import "UIView+PrismExtends.h"
#import "UIView+PrismDataVisualization.h"

@interface PrismDataFloatingComponent()
@property (nonatomic, strong) NSMutableArray<PrismDataFloatingView*> *allFloatingViews;
@property (nonatomic, copy) NSArray<PrismDataFilterItemConfig *> *filterConfig;
@end

@implementation PrismDataFloatingComponent

#pragma mark - public method
- (void)dispatchEvent:(PrismDispatchEvent)event withSender:(NSObject *)sender params:(NSDictionary *)params {
    if (event == PrismDispatchEventUIViewDidMoveToSuperview) {
        [self loadFloatingViewTo:sender];
    }
    
    if (event == PrismDispatchEventUIViewTouchesEnded_End ||
        event == PrismDispatchEventUIControlTouchAction ||
        event == PrismDispatchEventUITapGestureRecognizerAction) {
        [self updateStandardValue];
    }
}

- (void)reloadAllFloatingViewsWithFilterConfig:(NSArray<PrismDataFilterItemConfig *>*)filterConfig {
    self.filterConfig = filterConfig;
    if (!self.allFloatingViews.count) {
        return;
    }
    for (PrismDataFloatingView *floatingView in self.allFloatingViews) {
        [self updateFloatingView:floatingView];
    }
}

#pragma mark - private method
- (void)loadFloatingViewTo:(NSObject*)sender {
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
        if (!floatingView) {
            floatingView = [[PrismDataFloatingView alloc] init];
            floatingView.relatedInfos = [view.relatedInfos copy];
            [self.allFloatingViews addObject:floatingView];
            [self updateFloatingView:floatingView];
        }
        floatingView.hidden = ![self enable];
        if (![floatingView superview]) {
            BOOL needResize = view.frame.size.width < MinWidthOfPrismDataFloatingView || view.frame.size.height < MinHeightOfPrismDataFloatingView;
            if (needResize && (view.clipsToBounds || view.layer.masksToBounds)) {
                [self removeFloatingViewFrom:view.superview];
                [view.superview addSubview:floatingView];
            }
            else {
                [self removeFloatingViewFrom:view];
                [view addSubview:floatingView];
            }
            //trigger setter
            floatingView.frame = CGRectZero;
        }
    });
}

- (void)updateFloatingView:(PrismDataFloatingView*)floatingView {
    if (self.dataProvider && [self.dataProvider respondsToSelector:@selector(provideDataToComponent:withParams:withCompletion:)]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if ([floatingView relatedInfos]) {
            params[@"relatedInfos"] = [floatingView relatedInfos];
        }
        if (self.filterConfig) {
            params[@"filterConfig"] = self.filterConfig;
        }
        [self.dataProvider provideDataToComponent:self withParams:[params copy] withCompletion:^(PrismDataBaseModel * _Nonnull model) {
            if (![model isKindOfClass:[PrismDataFloatingModel class]]) {
                return;
            }
            floatingView.model = (PrismDataFloatingModel*)model;
        }];
    }
}

- (void)removeFloatingViewFrom:(UIView*)superview {
    NSArray<UIView*> *subviews = [superview subviews];
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[PrismDataFloatingView class]]) {
            [subview removeFromSuperview];
            break;
        }
    }
}

- (PrismDataFloatingView*)viewWithRelatedInfos:(PrismElementRelatedInfos*)relatedInfos
                                   onSuperview:(UIView*)superview
                              ignoreParameters:(BOOL)ignoreParameters {
    NSArray<PrismDataFloatingView*> *allFloatingViews = [self.allFloatingViews copy];
    for (PrismDataFloatingView *view in allFloatingViews) {
        BOOL isClickIdEqual = [view.relatedInfos clickTypeEventId].length ? [[view.relatedInfos clickTypeEventId] isEqualToString:[relatedInfos clickTypeEventId]] : YES;
        BOOL isExposureIdEqual = [view.relatedInfos exposureTypeEventId].length ? [[view.relatedInfos exposureTypeEventId] isEqualToString:[relatedInfos exposureTypeEventId]] : YES;
        BOOL isEqual = ignoreParameters ? (isClickIdEqual && isExposureIdEqual) : [view.relatedInfos isEqual:relatedInfos];
        if (isEqual && (!view.superview || [view.superview prism_hasRelationshipsWithView:superview])) {
            return view;
        }
    }
    return nil;
}

- (void)updateStandardValue {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *mainViewController = [self _protected_searchMainViewController];
        NSInteger standardValue = [self searchStandardValueOfViewController:mainViewController];
        NSArray<PrismDataFloatingView*> *allFloatingViews = [self.allFloatingViews copy];
        for (PrismDataFloatingView *view in allFloatingViews) {
            PrismDataFloatingModel *model = view.model;
            model.standardValue = standardValue;
            view.model = model;
        }
    });
}

- (NSInteger)searchStandardValueOfViewController:(UIViewController*)viewController {
    NSInteger standardValue = 0;
    NSMutableArray<UIView*> *visibleViewArray = [NSMutableArray array];
    [self ergodicSubviewsOf:viewController.view
       parentViewController:viewController
           visibleViewArray:visibleViewArray];
    if (!visibleViewArray.count) {
        return standardValue;
    }
    for (UIView *visibleView in visibleViewArray) {
        __block PrismDataFloatingView *floatingView = nil;
        [[visibleView subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[PrismDataFloatingView class]]) {
                floatingView = (PrismDataFloatingView*)obj;
                *stop = YES;
            }
        }];
        if (!floatingView) {
            continue;
        }
        standardValue = MAX(standardValue, floatingView.model.value);
    }
    return standardValue;
}

- (void)ergodicSubviewsOf:(UIView*)parentView
     parentViewController:(UIViewController*)parentViewController
         visibleViewArray:(NSMutableArray<UIView*> *)visibleViewArray {
    if (parentView.hidden == YES || parentView.alpha == 0 || parentView.userInteractionEnabled == NO) {
        return;
    }
    UIWindow *mainWindow = UIApplication.sharedApplication.delegate.window;
    CGRect frameInKeyWindow = [parentView.superview convertRect:parentView.frame toView:mainWindow];
    BOOL isVisible = CGRectContainsRect(mainWindow.bounds, frameInKeyWindow);
    if (!isVisible) {
        return;
    }
    if (parentView.prism_viewController != parentViewController) {
        return;
    }
    [visibleViewArray addObject:parentView];
    
    NSArray<UIView*> *subviews = parentView.subviews;
    if (!subviews.count) {
        return;
    }
    for (UIView *subview in subviews) {
        [self ergodicSubviewsOf:subview
           parentViewController:parentViewController
               visibleViewArray:visibleViewArray];
    }
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
