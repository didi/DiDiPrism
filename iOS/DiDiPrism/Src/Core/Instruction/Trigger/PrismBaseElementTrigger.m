//
//  PrismBaseElementTrigger.m
//  DiDiPrism
//
//  Created by hulk on 2022/3/17.
//

#import "PrismBaseElementTrigger.h"
// Category
#import "NSArray+PrismExtends.h"
// Trigger
#import "PrismCellTrigger.h"
#import "PrismControlTrigger.h"
#import "PrismEdgePanTrigger.h"
#import "PrismLongPressTrigger.h"
#import "PrismTapGestureTrigger.h"
#import "PrismH5Trigger.h"
#import "PrismTagTrigger.h"
#import "PrismTextFieldTrigger.h"

@interface PrismBaseElementTrigger()

@end

@implementation PrismBaseElementTrigger
#pragma mark - life cycle
+ (instancetype)elementTriggerWithFormatter:(PrismInstructionFormatter*)formatter {
    if ([formatter instructionFragmentWithType:PrismInstructionFragmentTypeH5View].count) {
        return [[PrismH5Trigger alloc] init];
    }
    if ([formatter instructionFragmentWithType:PrismInstructionFragmentTypeEvent].count) {
        return [[PrismTagTrigger alloc] init];
    }
    
    NSArray<NSString*> *viewMotionArray = [formatter instructionFragmentWithType:PrismInstructionFragmentTypeViewMotion];
    NSString *viewMotion = [viewMotionArray prism_stringWithIndex:1];
    if ([viewMotion isEqualToString:kViewMotionControlFlag]) {
        return [[PrismControlTrigger alloc] init];
    }
    else if ([viewMotion isEqualToString:kViewMotionTapGestureFlag]) {
        return [[PrismTapGestureTrigger alloc] init];
    }
    else if ([viewMotion isEqualToString:kViewMotionCellFlag]) {
        return [[PrismCellTrigger alloc] init];
    }
    else if ([viewMotion isEqualToString:kViewMotionEdgePanGestureFlag]) {
        return [[PrismEdgePanTrigger alloc] init];
    }
    else if ([viewMotion isEqualToString:kViewMotionLongPressGestureFlag]) {
        return [[PrismLongPressTrigger alloc] init];
    }
    else if ([viewMotion isEqualToString:kViewMotionTextFieldBFRFlag]) {
        return [[PrismTextFieldTrigger alloc] init];
    }
    
    return [[PrismBaseElementTrigger alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.needExecute = YES;
    }
    return self;
}

#pragma mark - public method
- (void)triggerWithElement:(NSObject *)element withNewValue:(id)newValue withDelay:(NSTimeInterval)delaySeconds {
    
}

- (void)highlightTheElement:(UIView *)element withNewColor:(UIColor *)color withDelay:(NSTimeInterval)delaySeconds withCompletion:(void (^)(void))block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
        CGRect elementFrame = [element.superview convertRect:element.frame toView:mainWindow];
        UIBezierPath *redPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(elementFrame.origin.x - 4, elementFrame.origin.y - 4, elementFrame.size.width + 8, elementFrame.size.height + 8) cornerRadius:5];
        CAShapeLayer *redLayer = [CAShapeLayer layer];
        redLayer.path = redPath.CGPath;
        redLayer.fillColor = color.CGColor;
        redLayer.opacity = 0.3;
        [mainWindow.layer addSublayer:redLayer];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.needExecute && block) {
                block();
            }
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [redLayer removeFromSuperlayer];
        });
    });
}

#pragma mark - private method

#pragma mark - setters

#pragma mark - getters

@end
