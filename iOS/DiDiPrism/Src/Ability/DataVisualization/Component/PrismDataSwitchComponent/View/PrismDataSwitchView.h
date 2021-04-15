//
//  PrismDataSwitchView.h
//  DiDiPrism
//
//  Created by hulk on 2021/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define PrismDataSwitchViewOrignYToBottom - PrismDataSwitchViewHeight - 13
#define PrismDataSwitchViewWidth 111
#define PrismDataSwitchViewHeight 35

@protocol PrismDataSwitchViewDelegate <NSObject>
- (void)didTouchDataModeButton:(UIButton*)sender;
- (void)didTouchHeatModeButton:(UIButton*)sender;
@end

@interface PrismDataSwitchView : UIView
@property (nonatomic, weak) id<PrismDataSwitchViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
