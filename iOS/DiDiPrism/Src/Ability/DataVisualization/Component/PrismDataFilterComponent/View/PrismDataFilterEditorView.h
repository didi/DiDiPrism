//
//  PrismDataFilterEditorView.h
//  DiDiPrism
//
//  Created by hulk on 2021/3/30.
//

#import <UIKit/UIKit.h>
// Model
#import "PrismDataFilterItem.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PrismDataFilterEditorViewDelegate <NSObject>

- (void)didTouchSaveButton:(UIButton*)sender withConfig:(NSArray<PrismDataFilterItemConfig*>*)config;
- (void)didTouchCancelButton:(UIButton*)sender;

@end

@interface PrismDataFilterEditorView : UIView
@property (nonatomic, weak) id<PrismDataFilterEditorViewDelegate> delegate;

- (void)setupWithConfig:(NSArray<PrismDataFilterItemConfig*>*)config;
@end

NS_ASSUME_NONNULL_END
