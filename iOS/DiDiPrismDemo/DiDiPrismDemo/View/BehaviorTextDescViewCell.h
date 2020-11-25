//
//  PrismBehaviorTextDescViewCell.h
//  DiDiPrismDemo
//
//  Created by hulk on 2019/11/7.
//

#import <UIKit/UIKit.h>
#import "PrismBehaviorTextModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BehaviorTextDescViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UILabel *failFlagLabel;

@property (nonatomic, strong) PrismBehaviorTextModel *textModel;
@end

NS_ASSUME_NONNULL_END
