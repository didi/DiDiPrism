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

@interface PrismDataFilterEditorView : UIView
@property (nonatomic, strong) void(^saveBlock)(void);
@property (nonatomic, strong) void(^cancelBlock)(void);

- (void)setupWithConfig:(NSArray<PrismDataFilterItemConfig*>*)config;
@end

NS_ASSUME_NONNULL_END
