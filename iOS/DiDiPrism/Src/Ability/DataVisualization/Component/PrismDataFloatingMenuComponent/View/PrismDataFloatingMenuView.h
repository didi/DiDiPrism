//
//  PrismDataFloatingMenuView.h
//  DiDiPrism
//
//  Created by hulk on 2021/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PrismDataFloatingMenuViewDelegate <NSObject>
- (void)didTouchNothing;
@end

@interface PrismDataFloatingMenuView : UIView
@property (nonatomic, weak) id<PrismDataFloatingMenuViewDelegate> delegate;

- (void)reload;
@end

NS_ASSUME_NONNULL_END
