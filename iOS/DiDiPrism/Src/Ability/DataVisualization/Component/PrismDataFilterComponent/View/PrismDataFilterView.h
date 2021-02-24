//
//  PrismDataFilterView.h
//  DiDiPrism
//
//  Created by hulk on 2021/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define PrismDataFilterViewOrignX 5
#define PrismDataFilterViewOrignYToBottom 8
#define PrismDataFilterViewFoldWidth 40
#define PrismDataFilterViewUnfoldWidth 320
#define PrismDataFilterViewHeight 40
#define PrismDataFilterViewSelectPageWidth 80

@protocol PrismDataFilterViewDelegate <NSObject>
- (void)didTouchLeftButton:(UIButton*)sender isFolding:(BOOL)isFolding;
- (void)didTouchMiddleButton:(UIButton*)sender isShow:(BOOL)isShow;
- (void)didTouchRightButton:(UIButton*)sender;
@end

@interface PrismDataFilterView : UIView
@property (nonatomic, weak) id<PrismDataFilterViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
