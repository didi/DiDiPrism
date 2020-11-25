//
//  UIScreenEdgePanGestureRecognizer+PrismIntercept.m
//  DiDiPrism
//
//  Created by hulk on 2019/10/15.
//

#import "UIScreenEdgePanGestureRecognizer+PrismIntercept.h"
#import "PrismBehaviorRecordManager.h"
#import "PrismEdgePanInstructionGenerator.h"
// Category
#import "UIView+PrismExtends.h"
// Util
#import "PrismRuntimeUtil.h"

// 响应链信息 +  gesture.edges = UIRectEdgeLeft;

@implementation UIScreenEdgePanGestureRecognizer (PrismIntercept)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(initWithTarget:action:) swizzledSelector:@selector(autoDot_initWithTarget:action:)];
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(addTarget:action:) swizzledSelector:@selector(autoDot_addTarget:action:)];
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(removeTarget:action:) swizzledSelector:@selector(autoDot_removeTarget:action:)];
    });
}

- (instancetype)autoDot_initWithTarget:(id)target action:(SEL)action {
    //原始逻辑
    UIScreenEdgePanGestureRecognizer *gesture = [self autoDot_initWithTarget:target action:action];
    
    [gesture addTarget:self action:@selector(autoDot_edgePanAction:)];
    
    return gesture;
}

- (void)autoDot_addTarget:(id)target action:(SEL)action {
    //原始逻辑
    [self autoDot_addTarget:target action:action];
    
    [self autoDot_addTarget:self action:@selector(autoDot_edgePanAction:)];
}

- (void)autoDot_removeTarget:(id)target action:(SEL)action {
    //原始逻辑
    [self autoDot_removeTarget:target action:action];
    
    [self autoDot_removeTarget:self action:@selector(autoDot_edgePanAction:)];
}


#pragma mark - actions
- (void)autoDot_edgePanAction:(UIScreenEdgePanGestureRecognizer*)edgePanGestureRecognizer {
    if ([[PrismBehaviorRecordManager sharedInstance] canUpload] == NO) {
        return;
    }
    
    if (edgePanGestureRecognizer.edges != UIRectEdgeLeft) {
        return;
    }
    
    if (edgePanGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIViewController *viewController = self.view.prism_viewController;
        UINavigationController *navigationController = [viewController isKindOfClass:[UINavigationController class]] ? (UINavigationController*)viewController : viewController.navigationController;
        [self setAutoDotNavigationController:navigationController];
        NSInteger viewControllerCount = navigationController.viewControllers.count;
        [self setAutoDotViewControllerCount:[NSNumber numberWithInteger:viewControllerCount]];
    }
    // 输入后退手势时，如果手指始终未离开屏幕，state会变为UIGestureRecognizerStateCancelled
    if (edgePanGestureRecognizer.state != UIGestureRecognizerStateEnded &&
        edgePanGestureRecognizer.state != UIGestureRecognizerStateCancelled) {
        return;
    }
    
    NSString *instruction = [PrismEdgePanInstructionGenerator getInstructionOfEdgePanGesture:self];
    if (!instruction.length) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UINavigationController *navigationController = [self autoDotNavigationController];
        NSInteger viewControllerCount = navigationController.viewControllers.count;
        if (navigationController && (viewControllerCount <= [self autoDotViewControllerCount].integerValue)) {
            [[PrismBehaviorRecordManager sharedInstance] addInstruction:instruction];
        }
    });
}

#pragma mark - private method

#pragma mark - property
- (NSNumber*)autoDotViewControllerCount {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setAutoDotViewControllerCount:(NSNumber*)autoDotViewControllerCount {
    objc_setAssociatedObject(self, @selector(autoDotViewControllerCount), autoDotViewControllerCount, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UINavigationController*)autoDotNavigationController {
    UINavigationController* (^block)(void) = objc_getAssociatedObject(self, @selector(autoDotNavigationController));
    return (block ? block() : nil);
}
- (void)setAutoDotNavigationController:(UINavigationController*)autoDotNavigationController {
    __weak UINavigationController *weakController = autoDotNavigationController;
    UINavigationController* (^block)(void) = ^{ return weakController; };
    objc_setAssociatedObject(self, @selector(autoDotNavigationController), block, OBJC_ASSOCIATION_COPY);
}
@end
