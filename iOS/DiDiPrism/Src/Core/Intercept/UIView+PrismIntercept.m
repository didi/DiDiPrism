//
//  UIView+PrismIntercept.m
//  DiDiPrism
//
//  Created by hulk on 2019/7/2.
//

#import "UIView+PrismIntercept.h"
#import "PrismBehaviorRecordManager.h"
#import "PrismCellInstructionGenerator.h"
// Util
#import "PrismRuntimeUtil.h"
#import "PrismInstructionParamUtil.h"

@implementation UIView (PrismIntercept)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(touchesEnded:withEvent:) swizzledSelector:@selector(autoDot_touchesEnded:withEvent:)];
    });
}

// 考虑到可能的手势影响，选择hook touchesEnded:withEvent:更合理。
- (void)autoDot_touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //原始逻辑
    Method original_TouchesEnded = class_getInstanceMethod([UIView class], @selector(autoDot_touchesEnded:withEvent:));
    IMP original_TouchesEnded_Method_Imp =  method_getImplementation(original_TouchesEnded);
    void (*functionPointer)(id, SEL, NSSet<UITouch *> *, UIEvent *) = (void (*)(id, SEL, NSSet<UITouch *> *, UIEvent *))original_TouchesEnded_Method_Imp;
    functionPointer(self, _cmd, touches, event);
    
    if ([[PrismBehaviorRecordManager sharedManager] canUpload] == NO) {
        return;
    }
    if ([self isKindOfClass:[UITableViewCell class]] || [self isKindOfClass:[UICollectionViewCell class]]) {
        NSString *instruction = [PrismCellInstructionGenerator getInstructionOfCell:self];
        if (instruction.length) {
            NSDictionary *eventParams = [PrismInstructionParamUtil getEventParamsWithElement:self];
            [[PrismBehaviorRecordManager sharedManager] addInstruction:instruction withEventParams:eventParams];
        }
    }
}
@end
