//
//  UIViewController+PrismIntercept.m
//  DiDiPrism
//
//  Created by hulk on 2019/8/13.
//

#import "UIViewController+PrismIntercept.h"
#import "PrismBehaviorRecordManager.h"
#import "PrismViewControllerInstructionGenerator.h"
// Util
#import "PrismRuntimeUtil.h"

@implementation UIViewController (PrismIntercept)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [PrismRuntimeUtil hookClass:[self class] originalSelector:@selector(viewDidAppear:) swizzledSelector:@selector(autoDot_viewDidAppear:)];
    });
}

- (void)autoDot_viewDidAppear:(BOOL)animated {
    [self autoDot_viewDidAppear:animated];
    
    if ([[PrismBehaviorRecordManager sharedInstance] canUpload] == NO) {
        return;
    }
    NSString *instruction = [PrismViewControllerInstructionGenerator getInstructionOfViewController:self];
    [[PrismBehaviorRecordManager sharedInstance] addInstruction:instruction];
}
@end
