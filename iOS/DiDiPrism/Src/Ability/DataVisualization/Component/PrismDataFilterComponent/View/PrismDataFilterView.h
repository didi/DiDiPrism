//
//  PrismDataFilterView.h
//  DiDiPrism
//
//  Created by hulk on 2021/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define PrismDataFilterViewOrignX 10
#define PrismDataFilterViewOrignYToBottom 30
#define PrismDataFilterViewFoldWidth 40
#define PrismDataFilterViewUnfoldWidth 320
#define PrismDataFilterViewHeight 40
#define PrismDataFilterViewSelectPageWidth 80

@protocol PrismDataFilterViewDelegate <NSObject>
- (void)didTouchFoldButton:(UIButton*)sender isFolding:(BOOL)isFolding;
- (void)didTouchFilterButton:(UIButton*)sender isShow:(BOOL)isShow;
- (void)didTouchThroughButton:(UIButton*)sender;
@end

@interface PrismDataFilterView : UIView
@property (nonatomic, weak) id<PrismDataFilterViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
