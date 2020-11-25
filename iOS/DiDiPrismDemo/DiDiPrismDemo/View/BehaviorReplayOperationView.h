//
//  PrismBehaviorReplayOperationView.h
//  DiDiPrismDemo
//
//  Created by hulk on 2019/10/9.
//

#import <UIKit/UIKit.h>
// model
#import "PrismBehaviorModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BehaviorReplayOperationViewDelegate <NSObject>

- (void)didGoonButtonSelected;
- (void)didPauseButtonSelected;
- (void)didStopButtonSelected;

@end

@interface BehaviorReplayOperationView : UIView
@property (nonatomic, weak) id<BehaviorReplayOperationViewDelegate> delegate;
@property (nonatomic, strong, nullable) PrismBehaviorListModel *model;
@end

NS_ASSUME_NONNULL_END
