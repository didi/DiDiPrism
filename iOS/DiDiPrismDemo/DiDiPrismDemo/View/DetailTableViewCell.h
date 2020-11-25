//
//  DetailTableViewCell.h
//  DiDiPrismDemo
//
//  Created by hulk on 2020/10/26.
//  Copyright © 2020 prism. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DetailTableViewCellDelegate <NSObject>

- (void)didGoButtonSelectedWithIndex:(NSInteger)index;

@end

@interface DetailTableViewCell : UITableViewCell
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) id<DetailTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
