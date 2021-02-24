//
//  PrismDataFilterComponent.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import "PrismDataFilterComponent.h"
// View
#import "PrismDataFilterView.h"

@interface PrismDataFilterComponent()
@property (nonatomic, strong) PrismDataFilterView *filterView;
@end

@implementation PrismDataFilterComponent
#pragma mark - life cycle

#pragma mark - public method

#pragma mark - private method

#pragma mark - setters
- (void)setEnable:(BOOL)enable {
    [super setEnable:enable];
    
    if (self.enable) {
        UIWindow *mainWindow = UIApplication.sharedApplication.delegate.window;
        [mainWindow addSubview:self.filterView];
    }
    else {
        [self.filterView removeFromSuperview];
    }
}

#pragma mark - getters
- (PrismDataFilterView *)filterView {
    if (!_filterView) {
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        
        _filterView = [[PrismDataFilterView alloc] initWithFrame:CGRectMake(10, screenHeight - PrismDataFilterViewHeight - 20, PrismDataFilterViewUnfoldWidth, PrismDataFilterViewHeight)];
    }
    return _filterView;
}
@end
