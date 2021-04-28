//
//  PrismDataBubbleView.h
//  DiDiPrism
//
//  Created by hulk on 2021/2/23.
//

#import <UIKit/UIKit.h>
#import "PrismDataBubbleModel.h"

NS_ASSUME_NONNULL_BEGIN

#define PrismDataBubbleViewFoldWidth 38
#define PrismDataBubbleViewUnFoldWidth 155
#define PrismDataBubbleViewHeight 38

@protocol PrismDataBubbleViewDelegate <NSObject>
- (void)didTouchView;
@end

@interface PrismDataBubbleView : UIView
@property (nonatomic, strong) PrismDataBubbleModel *model;
@property (nonatomic, weak) id<PrismDataBubbleViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
