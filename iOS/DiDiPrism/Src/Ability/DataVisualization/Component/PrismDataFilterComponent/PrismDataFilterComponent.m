//
//  PrismDataFilterComponent.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/22.
//

#import "PrismDataFilterComponent.h"
// View
#import "PrismDataFilterView.h"
#import "PrismDataFilterEditorView.h"

@interface PrismDataFilterComponent() <PrismDataFilterViewDelegate>
@property (nonatomic, strong) PrismDataFilterView *filterView;
@property (nonatomic, strong) PrismDataFilterEditorView *editorView;
@end

@implementation PrismDataFilterComponent
#pragma mark - life cycle

#pragma mark - public method

#pragma mark - private method

#pragma mark - delegate
#pragma mark PrismDataFilterViewDelegate
- (void)didTouchFoldButton:(UIButton *)sender isFolding:(BOOL)isFolding {
    
}

- (void)didTouchFilterButton:(UIButton *)sender isShow:(BOOL)isShow {
    if (![self.editorView superview]) {
        UIWindow *mainWindow = UIApplication.sharedApplication.delegate.window;
        [mainWindow addSubview:self.editorView];
    }
    [self.editorView setupWithConfig:self.config];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat width = 320;
    CGFloat height = 60 + 50 + self.config.count * 40;
    CGFloat originX = (screenWidth - width) / 2;
    CGFloat originY = self.filterView.frame.origin.y - 10 - height;
    self.editorView.frame = CGRectMake(originX, originY, width, height);
}

- (void)didTouchThroughButton:(UIButton *)sender {
    
}

#pragma mark - setters
- (void)setEnable:(BOOL)enable {
    [super setEnable:enable];
    
    if (self.enable) {
        UIWindow *mainWindow = UIApplication.sharedApplication.delegate.window;
        [mainWindow addSubview:self.filterView];
    }
    else {
        [self.filterView removeFromSuperview];
        [self.editorView removeFromSuperview];
    }
}

#pragma mark - getters
- (PrismDataFilterView *)filterView {
    if (!_filterView) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        _filterView = [[PrismDataFilterView alloc] initWithFrame:CGRectMake((screenWidth - PrismDataFilterViewUnfoldWidth) / 2, screenHeight - PrismDataFilterViewHeight - 30, PrismDataFilterViewUnfoldWidth, PrismDataFilterViewHeight)];
        _filterView.delegate = self;
    }
    return _filterView;
}

- (PrismDataFilterEditorView *)editorView {
    if (!_editorView) {
        _editorView = [[PrismDataFilterEditorView alloc] init];
    }
    return _editorView;
}
@end
